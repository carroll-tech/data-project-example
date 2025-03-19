## [0.4.1](https://github.com/jolfr/data-project-example/compare/v0.4.0...v0.4.1) (2025-03-19)


### Bug Fixes

* **ci:** changed to run on all workflow changes ([e5a8328](https://github.com/jolfr/data-project-example/commit/e5a8328a0a4d983977638919f3e7fa53b6d94690))
* **ci:** refactor workflows to run networking module using matrix strategy ([027945b](https://github.com/jolfr/data-project-example/commit/027945b9d3c926cdbbc4f3d2d1bb4fa1f3d274e9))
* **ci:** updated to not output sensitive values ([338b0ff](https://github.com/jolfr/data-project-example/commit/338b0ff29435face95e33a049d1c00a56b65b207))
* **infra:** add backend config for ports ([f959d01](https://github.com/jolfr/data-project-example/commit/f959d01b46018ce51d8982f062de4781a46a1ee2))
* **infra:** add lookup for global static IP in ArgoCD data.tf ([737184d](https://github.com/jolfr/data-project-example/commit/737184dd10d1f0e8865679e37a3833e24977aa9d))
* **infra:** add support for setting values in helm_release for argo-cd ([b1cc8c5](https://github.com/jolfr/data-project-example/commit/b1cc8c51981de4f840d130bef2c0f073e0872db1))
* **infra:** added region to outputs ([c5eed89](https://github.com/jolfr/data-project-example/commit/c5eed8969ee7366adfe0ec38b485db5a00e0d0bb))
* **infra:** added tfe provider for output lookup ([836b7c7](https://github.com/jolfr/data-project-example/commit/836b7c72c41ab0829c0fd8470ce9fc8079a8d352))
* **infra:** correct global static IP usage in ArgoCD configuration ([cf5cd00](https://github.com/jolfr/data-project-example/commit/cf5cd00e4f3106f7df74993f8490afa3234d9a4c))
* **infra:** fixing output passing to google provider ([b3d67e1](https://github.com/jolfr/data-project-example/commit/b3d67e135e81e8566a74b6b1aced5b8df45b980d))
* **infra:** remove ArgoCD server ingress configuration ([0a6316d](https://github.com/jolfr/data-project-example/commit/0a6316d74354ff4a071db2a2d9c6fb8bbd3a6fa0))
* **infra:** remove argocd_admin_password passthrough ([92afe7c](https://github.com/jolfr/data-project-example/commit/92afe7ccd41fab09b450bb37322778747db8a57d))
* **infra:** remove backticks from kubernetes annotation key ([1e1f33b](https://github.com/jolfr/data-project-example/commit/1e1f33b3ec9acb09a9bbf4de637a852317510141))
* **infra:** rollback helm provider version ([efcf86c](https://github.com/jolfr/data-project-example/commit/efcf86cbd12d95ff5b8226f36690021626acc228))
* **infra:** updated backend config to point to ui service ([fe3e163](https://github.com/jolfr/data-project-example/commit/fe3e163a457235ff979a7eeb421f9844dec8abb4))
* **infra:** updated domain name ([2b0814c](https://github.com/jolfr/data-project-example/commit/2b0814c6be5341d88f20f0a98904e75048d85e70))
* **infra:** use PREMIUM network tier for INTERNAL addresses ([b01b2c5](https://github.com/jolfr/data-project-example/commit/b01b2c55dc48c632b1e55156550db7cb7da292a9))


### Features

* **infra:** add ArgoCD Helm chart ([cf7df45](https://github.com/jolfr/data-project-example/commit/cf7df45dbaaf08a95c9d019805ba22c503b9207f))
* **infra:** add argocd_admin_password variable ([f97b656](https://github.com/jolfr/data-project-example/commit/f97b656f35fd5c494bfbab7cfee48e1034bf49cf))
* **infra:** add cd domain lookup from networking outputs ([1602b73](https://github.com/jolfr/data-project-example/commit/1602b7345bdf2104c2fafd21954ce233d50d6869))
* **infra:** add hello-world application to ArgoCD chart ([e0f14f3](https://github.com/jolfr/data-project-example/commit/e0f14f319a721771052da4f53673eef617dd6b03))
* **infra:** add networking tfe outputs lookup ([8e166b0](https://github.com/jolfr/data-project-example/commit/8e166b07718bca70e05c23f1197198d8c0bf5dfd))
* **infra:** add static IP allocation module ([e4109f6](https://github.com/jolfr/data-project-example/commit/e4109f62934407364c2925da444ee81085e2ec9e))
* **infra:** added argo cd helm chart resource ([6bcc41a](https://github.com/jolfr/data-project-example/commit/6bcc41a1a595a93d88965f09844f813c3d93d937))
* **infra:** added config for kubernetes and helm providers ([80e753a](https://github.com/jolfr/data-project-example/commit/80e753a208cca373de1ab26c5ea725f95fb4c10a))
* **infra:** added creation of namespace ([ba72086](https://github.com/jolfr/data-project-example/commit/ba720860d3eff3d1444e26352b81bc8609e8c148))
* **infra:** added gke alb configuration ([1b4ab63](https://github.com/jolfr/data-project-example/commit/1b4ab6375a482bb92ff23b99e0439a1e9c53efc7))
* **infra:** added output lookup from cluster module ([5ec588d](https://github.com/jolfr/data-project-example/commit/5ec588d536a47985d7544e1f0d1e4c328cac183c))
* **infra:** added terraform config definition ([60209da](https://github.com/jolfr/data-project-example/commit/60209dad07557a88c70612abfd59fab940bcc46b))
* **infra:** added values file passthrough for multiple values files ([c3bdb46](https://github.com/jolfr/data-project-example/commit/c3bdb467a19ba76b917f509c36ec0b541709003d))
* **infra:** configure static IPs with fully defined domains ([8b3d32d](https://github.com/jolfr/data-project-example/commit/8b3d32d82c0c4e66871ddd384d906c585f3bc6db))
* **infra:** configured google provider ([f64e5eb](https://github.com/jolfr/data-project-example/commit/f64e5eb9e2bd6f3cb0a7e9de64a3d66739ddecdf))
* **infra:** enhance networking module to support per-subdomain configuration ([a160b93](https://github.com/jolfr/data-project-example/commit/a160b933cee0add0dc050ab2985d0f7da03e53fc))
* **infra:** refactor networking outputs to expose static IP details map ([35c9f0a](https://github.com/jolfr/data-project-example/commit/35c9f0ab15139703e5bed0847ef5c60750e09eac))
* **infra:** set global domain ([fe5521a](https://github.com/jolfr/data-project-example/commit/fe5521a6aaf8153d00656a25f1195c638a9051ac))



