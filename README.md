# cidmemo-team-sandbox

## Use Case

A central cloud operations team deploys a sandbox for a developer team. 

This repo does not do much because it's  demo. In real life however, the most common use case is to bootstrap a sandbox that is pre-configured to connect with shared resources, especially networking (think hub and spoke architectures).

### Considerations

If you're an organization, here are some considerations to think about.

- What permissions at which scope do teams receive?_Why?_
- Why should every team get their own Azure Container Registry?

## Resources deployed

| Resource | Description |
|:--|:--|
| Azure Resource Group | Sandbox logical and security boundary |
| Azure Key Vault | Can be pre-populated with credentials for team |
| Azure Container Registry | Team stores their Docker images here |
