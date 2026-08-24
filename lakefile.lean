import Lake
open Lake DSL

package «GTH» where
  -- Package configuration options

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.8.0"

@[default_target]
lean_lib «GTH» where
  roots := #[`GTH]
