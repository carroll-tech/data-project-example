## [0.2.2](https://github.com/jolfr/data-project-example/compare/v0.2.1...v0.2.2) (2025-03-17)


### Bug Fixes

* **ci:** add terraform plan job for infrastructure/cluster ([a5f1789](https://github.com/jolfr/data-project-example/commit/a5f178952d1ab2f246f67686af8907f8e607ebda))
* **ci:** added full fetch ([a017189](https://github.com/jolfr/data-project-example/commit/a017189fe52502ea33af1aa948b37d684c9ec9a6))
* **ci:** added head ref and full fetch ([ecad57b](https://github.com/jolfr/data-project-example/commit/ecad57b4571b8e0411c54a6461eb1cdd9e36ccc8))
* **ci:** added manual tag and push changelog ([66b33f9](https://github.com/jolfr/data-project-example/commit/66b33f932240d4d55302a022ecf8558e4d29f768))
* **ci:** adding conditional call to apply for terraform workflow ([ff00d05](https://github.com/jolfr/data-project-example/commit/ff00d05c665e27686c34fb53ae79c22ebba57f8b))
* **ci:** adding manual workflow dispatch trigger ([66dfe95](https://github.com/jolfr/data-project-example/commit/66dfe9542ba6de34f3fbc42852cb094b1d333145))
* **ci:** adding permissions for write to repo ([59527be](https://github.com/jolfr/data-project-example/commit/59527becdcfc681dce0d35122bc5c97ed627d701))
* **ci:** adding skip commit to pr workflow ([c5d8c13](https://github.com/jolfr/data-project-example/commit/c5d8c13df23d772cf46e769846360543123536ce))
* **ci:** adding skip pull and push for release ([8f5389d](https://github.com/jolfr/data-project-example/commit/8f5389d867a7fad392fd6e5c964e3b6d6e3fe996))
* **ci:** adding trigger on ci changes ([05b3c55](https://github.com/jolfr/data-project-example/commit/05b3c55a787ff382afc961904a558a6f103677e3))
* **ci:** allowing commit and tag but no push ([7ef58aa](https://github.com/jolfr/data-project-example/commit/7ef58aa6b904a6843a7ade839902d78ba00f88e3))
* **ci:** disabling push on changelog action ([80cae5f](https://github.com/jolfr/data-project-example/commit/80cae5f9ef7e7378a79993a74dd880ffe329a6ac))
* **ci:** fixing conditional run bug for terraform plan ([0cf2b90](https://github.com/jolfr/data-project-example/commit/0cf2b90a72f7fef0e6bd2f2060fc7adf415cdc07))
* **ci:** fixing plan output ([d9c26e0](https://github.com/jolfr/data-project-example/commit/d9c26e090496c45d7b8bf5d4b737ea3b41a678ee))
* **ci:** giving release workflow write permissions for versioning ([70ba3e4](https://github.com/jolfr/data-project-example/commit/70ba3e4b4801819cb93d2dd50493820af0b39f27))
* **ci:** granting permissions to main workflow ([b4c956e](https://github.com/jolfr/data-project-example/commit/b4c956ed76005e83579f3b371e41034baf1e6fde))
* **ci:** removing skip bump ([53778fc](https://github.com/jolfr/data-project-example/commit/53778fcf89b9dcd870761eff08ddd202689bb542))
* **ci:** switching to use release for all write actions regarding versioning ([8c24a84](https://github.com/jolfr/data-project-example/commit/8c24a845d3de23cde4a57b10db58290cf640672c))
* **ci:** updated workflow permissions to allow pr comment ([98cdabd](https://github.com/jolfr/data-project-example/commit/98cdabd1e096108247711a6dbaf8b882d0e48d0d))
* **ci:** updating filter paths for workflows ([820f38c](https://github.com/jolfr/data-project-example/commit/820f38cf40e12532a939fe203b9807a1946877e2))
* **ci:** updating pull request comment for terraform plan ([6585ef8](https://github.com/jolfr/data-project-example/commit/6585ef873f155c8429a304ca3dd966eb9c96bd42))
* **infra:** added outputs to allow subsequent modules to lookup the cluster ([da38dc1](https://github.com/jolfr/data-project-example/commit/da38dc1179cb8ebbba2cf2fe77c3931fad19abbe))
* **infra:** adding default node roles to service account ([578e15b](https://github.com/jolfr/data-project-example/commit/578e15b85ebaf3233307c7f11ec77c58ba8e9e2d))
* **infra:** changed default region to us-central1 ([b6a0f83](https://github.com/jolfr/data-project-example/commit/b6a0f8338ddad55aac8a4df5f8c9d3b0e2724395))
* **infra:** updating permissions to allow service account to deploy node pool ([c4f51eb](https://github.com/jolfr/data-project-example/commit/c4f51ebaf9f4165ce7746bad72c6639926aadcea))
* **workflow:** correct expression syntax in pull request workflow ([f0158c2](https://github.com/jolfr/data-project-example/commit/f0158c238f9129ff7aab2f73a5c6452645d2c93e))
* **workflows:** disabled skip on empty ([060e7bd](https://github.com/jolfr/data-project-example/commit/060e7bdf5cae5c359f4960fd3fce980e4918b8fa))


### Features

* **ci:** add terraform apply workflow ([2682949](https://github.com/jolfr/data-project-example/commit/2682949259df7ce77da93c1dae0869bd74bf45fb))
* **ci:** add terraform workflow for module management ([89dedaa](https://github.com/jolfr/data-project-example/commit/89dedaaefb1c9dd4f892e87d0b4b5c7a429da33e))
* **ci:** added terraform plan pr workflow ([ffe3a14](https://github.com/jolfr/data-project-example/commit/ffe3a14baaa8ceef686fae7956d96b2b08f8b167))
* **docs:** add blockchain data LLM project documentation ([0e536f7](https://github.com/jolfr/data-project-example/commit/0e536f783e36f8df62e6ef59403d2603641ef98a))
* **infra:** added basic cluster resource definition ([9186297](https://github.com/jolfr/data-project-example/commit/9186297241d47b6930b617449bcb87f65ab3638d))
* **infra:** added initial definition for general node pool ([7d3196e](https://github.com/jolfr/data-project-example/commit/7d3196e6109283fb09e0ae1b5254d4843bdbd386))
* **infra:** added provider configuration ([0d59ecf](https://github.com/jolfr/data-project-example/commit/0d59ecf48a2f3ce75510d1aa86621a4a5d51ed69))
* **infra:** added terraform block with config to hcp cloud and google provider ([6440c71](https://github.com/jolfr/data-project-example/commit/6440c71981e81f58342ac854582be2bd9e578efd))



