---
title: "Blog"
date: 2026-05-07T13:25:51+0200
draft: false
tags: []
---

# Agent harnesses, and why AgentCore's managed harness matters

People throw the word *harness* around a lot, and they don't always mean the same thing. Some people mean the agent loop. Others mean the framework wrapped around the loop, or the runtime hosting the whole thing. The terms aren't equivalent, and the difference shows up the minute you have to decide what your team is going to build versus buy.

So this is what an agent harness actually is, what's inside one, and why the managed harness AWS just shipped in Bedrock AgentCore changes the math for most teams.

## Framework vs. harness

A framework like LangChain, LangGraph, AutoGen, or CrewAI hands you abstractions (chains, graphs, retrievers, memory adapters) and expects you to wire them together. The assumption baked in is that there's a developer doing the assembly.

A harness flips that around. There is no assembly step. A harness is, at the core, a while loop with a tool registry and a permission layer, with everything pre-wired. You give it a goal, it runs. Claude Code is the obvious example: point it at a repo, it works.

That distinction gets operational fast. Who owns the loop? The context budget? The tool dispatch policy? The failure modes? With a framework, you do. With a harness, the harness does.

## What's inside a harness

Most production-grade harnesses converge on the same nine pieces. They're worth listing because they're the build cost if you don't already have a harness.

**1. The iteration loop.** The outer while loop. Read the system prompt, pick a tool, run it, feed the result back, loop. Stops when the model produces a text-only response or hits an iteration cap. Everything else exists to support this.

**2. Context management.** Conversations grow. The harness has to decide what to keep, what to summarize, and what to throw away. Claude Code's compaction kicks in around 80 to 90 percent of the budget; older history gets summarized, recent messages stay whole. Compaction done badly degrades agent quality silently, and you find out weeks later when your eval scores drift.

**3. Skills and tools.** Tools are the universal primitives: read file, edit file, run bash, search code. Skills sit on top and encode workflow-specific knowledge, usually as markdown files. A registry tracks what's available, what permission each one needs, and how calls dispatch.

**4. Sub-agent management.** When a task is too big or too parallel for one thread, the harness spawns isolated sub-agents. Each one gets its own session, a restricted toolset, and a focused system prompt. The pattern is to spawn them, restrict what they can do, and collect their outputs back into the parent.

**5. Built-in skills.** Beyond user-supplied skills, every modern harness ships with a baseline: file ops, shell execution, code navigation. Vendor harnesses also bundle higher-level operations, like opening a PR or running tests, that encode their team's conventions.

**6. Session persistence.** Long sessions are stateful, and a process crash erases everything unless state is on disk. The pattern that works is append-only JSON, one event per line. You can resume exactly where you left off, which matters more than people think it does, until they lose a four-hour session.

**7. System prompt assembly.** The system prompt isn't static. It's a pipeline that walks ancestor directories looking for files like `CLAUDE.md` or `AGENTS.md` and injects them. One gotcha: order matters. Keep the static portion first or you'll break prefix caching and watch your token bill move in the wrong direction.

**8. Lifecycle hooks.** Pre-tool hooks fire before execution and can allow, deny, or modify a call. Post-tool hooks run after and inspect results. Hooks are how enterprises bolt on policy enforcement without forking the harness.

**9. Permissions and safety.** A hierarchy of permission modes: read-only, workspace, full. Each tool declares the minimum it requires, and the harness enforces this at dispatch. For a generic tool like bash, a serious harness classifies commands dynamically. `ls`, `cat`, `grep` stay read-only. `rm`, `sudo`, `shutdown` jump to full access. Anything else lands at workspace. On top of the static rules, the agent can pause and ask a human before doing something destructive.

That's nine components you have to design, build, maintain, and keep coherent with each other. Which is the actual problem.

## The build-vs-buy problem

The pieces aren't novel. Most teams shipping agents have built rough versions of all of them. The cost is keeping them coherent over time. Context compaction interacts with prompt caching. Permissions interact with sub-agents. Hooks need a stable contract across harness versions. Memory persistence has to survive crashes and survive schema changes. The more components you wire together, the more of your engineering time goes to maintaining seams rather than improving the agent itself.

This is also where the prototype-to-production chasm actually lives. A demo that works on a laptop tends to break the moment it has to deal with multi-tenancy, IAM boundaries, observability, idle-timeout semantics, VPC egress, and disaster recovery. None of that is the agent. All of it is undifferentiated work.

## AgentCore's managed harness

AWS's move with Bedrock AgentCore is to take the harness layer itself and offer it as a managed surface. You declare the agent (model, system prompt, tools, skills, memory, identity), and AgentCore wires up the loop and everything around it. There is no harness code to maintain.

What you actually get:

The runtime is AgentCore Runtime, which executes the agent in an isolated microVM with attached storage and shell execution, and gives you the option to bring your own container. Memory comes from AgentCore Memory: short-term session persistence (the microVM holds session state for up to 8 hours), plus long-term event extraction across sessions so personalization survives both session boundaries and crashes. Identity is per-harness IAM execution roles, with optional OAuth or JWT for outbound calls. Observability is on by default. Every session emits OpenTelemetry-compatible spans for model calls, tool calls, memory events, tokens, and latency, going to whatever pipeline your team already uses. Models are open: Bedrock as the default, plus OpenAI, Gemini, and any OpenAI-API-compatible provider.

The piece that separates this from a "we ran your agent in a container" offering is **invocation-time configuration override**. The same harness can be invoked with a different model, a different system prompt, a different tool subset, or a different skill path on every request. That one capability is what unlocks the patterns that are otherwise expensive to build yourself.

You can iterate on prompts and models without redeploying. Iteration latency drops from a deploy cycle to one API call. You can personalize, by injecting user-specific context into the system prompt at invocation time without standing up per-user agent versions. You can do real multi-tenancy, where each tenant gets their own tool subset and behavior on top of one shared agent template, instead of running parallel stacks per tenant. And you can manage context economics by passing only the tools the current call actually needs. Smaller prompt, lower token cost, lower latency, and a tighter security blast radius, since a tool that isn't in the prompt cannot be invoked.

The agent loop, the runtime, the identity boundaries, the memory, the observability: AgentCore owns those. Your team owns behavior, tools, and prompts.

## Where it fits, and where it doesn't

The trade-off here is the usual managed-service trade-off. You give up some control over the loop in exchange for not having to maintain it. AWS is honest about this in their own framing. If you need fine-grained customization of the agent loop, you drop down to plain AgentCore and assemble the pieces yourself.

The managed harness is the right default when you're early in an agent's life and want to iterate on prompts, tools, and models without a deploy in between. It's the right default when you need production-grade observability, identity, and durability and you don't have a platform team to staff that yourself. And it's the right default when you have multi-tenant or multi-configuration requirements that would otherwise push you into running parallel agent stacks.

It's the wrong default in fewer situations than the marketing makes it sound, but those situations are real. If you need a non-standard execution loop, like a planner-executor with custom checkpointing semantics, you'll outgrow the managed surface. If your team has already invested in a harness and is getting real value from it, switching is mostly cost. And if you have regulatory or vendor constraints that rule out a managed AWS surface, none of this applies.

What I think is the most useful property is the migration story. Because the managed harness is built on the same AgentCore primitives you'd use directly, leaving the managed surface later doesn't mean rebuilding. Tools, memory, identity, and observability carry over. It's an exit ramp, not a lock-in.

## Why this matters for engineering leaders

Two practical implications.

First, the ratio of differentiated to undifferentiated work shifts. Teams that previously spent quarters on harness plumbing get those quarters back for the things that actually distinguish their agent: the tools they wire up, the prompts they tune, the evaluations they run, the integrations they ship.

Second, build-vs-buy stops being all-or-nothing. The managed harness is a starting point you can leave when the constraints change. That's a different conversation than "do we adopt this platform?"

The space moves fast, and any specific managed offering will look different a year from now. The shift worth paying attention to is more durable than that. The harness is becoming its own category of infrastructure, sitting between the framework above and the runtime below, with its own components and its own trade-offs. The teams that recognize it as a category will make better decisions about it than the teams still arguing about what to call it.
