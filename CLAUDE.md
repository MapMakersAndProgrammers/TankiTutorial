# TankiTutorial identifier cleanup

ActionScript 3 sources decompiled from a SWF with JPEXS FFDec, after custom scripts restored package, class and method names. The current work is replacing the identifiers that are still machine-generated with readable names. Every file is reviewed by hand after you edit it, so a small diff you can justify matters more than coverage.

## Scope

Work only in `src/TankiTutorial/`, and only on the file(s) named in the request. One file per request unless told otherwise; do not move on to the next file on your own.

Never edit (reading for context is fine):

- `src/TankiTutorial/alternativa/engine3d/` and `src/TankiTutorial/alternativa/gfx/` (engine code, handled separately)
- `src/TankiTutorial/_assets/`
- asset embed classes: any class carrying both `[Embed(...)]` and `[ExcludeClass]` metadata
- `utils/mapping.json` and `utils/packagemap.json`

## Rename only

IMPORTANT: change identifier names and nothing else. The token stream of a file must be identical before and after, apart from renamed identifiers.

- No reformatting, whitespace changes, reordering, or moving declarations.
- No adding or removing `this.`, casts, type annotations, imports, or comments.
- No fixing bugs, dead code, or decompiler artifacts (redundant casts, odd control flow, `§§` constructs).
- No correcting names that are already real, even when misspelled. `hideBimap`, `intergateVelocities` and `shoudCalculateAverageValues` are original names.

If you notice something worth fixing, put it in the report instead.

## What counts as a generated identifier

1. `_locN_` locals (FFDec register names).
2. `paramN` parameters (FFDec's names for parameters).
3. Random words from FFDec's "Rename invalid identifiers > Random word": lowercase pronounceable nonsense, 3 to 10 letters, strictly alternating consonant and vowel with `y` as a vowel (`becatysaw`, `cabor`, `juh`, `zetiniby`). They appear on fields and constants, and may appear on locals and parameters of functions that contain closures.

Real names can fit pattern 3 (`body`, `color`, `camera`, `timer`, `velocity`). If a name is a sensible word for what it holds, it is real: leave it. Some locals already have real names; leave those too.

Out of scope even when the name is a random word:

- Class names, package names, methods and accessors. The deobfuscation mapping covers these; report any that are still random words instead of renaming them.
- Anything declared in an excluded directory, including members that in-scope classes inherit from or access on engine classes. Find the declaration before renaming a member; if it is not in an in-scope file, leave every use of it alone.

## Choosing a name

Use evidence from this repository, strongest first:

- **Embed fields.** Embed classes are named `Owner_fieldName` by the compiler, so a field of `ProgressBarSkin` initialised with `ProgressBarSkin_hpLeftDmCls` was originally `hpLeftDmCls`.
- **Accessors and trivial methods.** A field returned by getter `foo`, or read and written by `getFoo()`, `setFoo(x)`, `isFoo()`, is `foo` in the form the conventions below prescribe.
- **Flow between named and unnamed things.** A parameter stored into a named field, a value passed to a named parameter, the result of `createX()` or `getX()`.
- **String literals.** XML attribute or config keys read into the variable, event types, error and trace messages, a string constant's own value.
- **The same random word elsewhere.** In the mapping one random word always stands for one original method name across unrelated classes (`napyr` is `clear`, `byr` is `destroy` everywhere), so a random-word field seen in several classes very likely had one original name. Look at the other occurrences and keep the name consistent.
- **Type and role.** A type-derived name (`matrix`, `rayHit`) is fine when the variable is simply "the X" of its function. Do not invent a more specific role than the code shows.

Further rules:

- Use the vocabulary the code already uses (hull, turret, track, chassis, bonus, parachute, cords, trigger, renderer) rather than synonyms.
- Rename only when you can point at the evidence. If you would be guessing, leave the identifier as it is and list it in the report. A plausible wrong name is worse than `_loc3_`.
- Loop counters are `i`, `j`, `k`.
- In inlined vector and matrix math (physics, colliders), name scalar temporaries by component when that is clear (`dx`, `dy`, `dz`, `dot`) and leave them otherwise.
- When one `_locN_` is reused for two unrelated purposes it cannot be split. Give it a neutral name that fits both uses, or leave it, and note it in the report.
- Give a parameter the same name in every override and interface implementation of a method where you can.

## Conventions

Taken from the recovered method names, and applying to new names:

- lowerCamelCase for locals, parameters and fields.
- Event handlers `onX`; boolean getters `isX` / `hasX` / `canX`; counts `numX`; identifiers `xId`.
- Acronyms keep the casing already in use: `FPS`, `FOV`, `UV`, `XYZ`, `AABB`, `BSP`, `SFX`, `URL`, `XML`, `3D` (`maxFPS`, `getBattleScene3D`).
- American spelling (`color`).
- Fields have no prefix (finished, channel, focalLength); `_foo` is used only for the backing field of accessor `foo` (_width, _parent, _command).
- Static vars are plain lowerCamelCase (loader, currentStep, views, shadowPrograms).
- Constants holding numbers or strings are UPPER_SNAKE_CASE, public or private (THRESHOLD_STEP, CHUNK_MAIN, MOUSE_DOWN, PT_BR).
- Constants holding object instances, including scratch objects, are lowerCamelCase (clientLog, registries, treeSphere, splitCoordsX).
- Reusable scratch objects are `private static const` created with `new` (treeSphere, staticSphere, coords).
- A setter's parameter is `value` (set x(value:Number)).
- An event handler parameter is `e` for a plain Event, and the lowerCamel type name for subclasses (mouseEvent, keyboardEvent).
- A constructor parameter has the name of the field it is stored in (radiusX → radiusX, width → _width).
- Loop counters are i, j, k; lengths are len or length, or xLength/xCount for a specific collection (facesLength, vertsCount).
- Locals of a common type are named after the type in lowerCamel (face, vertex, object, child, mesh, context, camera).
- Short names are normal in tight code: res (result), src, w, v, a/b/c for vertices or points, t for a parameter along a ray.
- Inlined vector math names component scalars by vector and axis (ax, ay, az, abx, aby, abz, nx, ny, nz, dx, dy, dz, dot).
- Boolean fields, params and locals are bare adjectives or verb phrases (finished, enabled, behind, infront, sort); no is/has/can.
- is/has/can prefixes are for boolean methods and getters (isReady, isEmpty, hasContacts, canAddEffect).
- The use prefix marks feature switches (useLight, useShadowMap, useCapture).
- Arrays, Vectors and Dictionaries take plural nouns (faces, lights, programs, textures); no Array/Vector/Dict suffix.
- `xList` names the head of a linked list of Face, Vertex or Object3D (faceList, vertexList, objectList); a local Dictionary used as a lookup is map.
- Counts exposed as properties are numX (numChildren, numTriangles, numSounds); identifiers are xId (bonusId, context3DId).
- An embed field is named exactly as its Owner_fieldName class, suffix included (finishMCClass, deleteMC, hpLeftDmCls).
- Acronyms: FPS, AABB, URL, XML, BSP, SFX, UV, 3D all caps; Id and Ms in camel form (bonusId, averageTimeInMs).

## Safety checks for every rename

- A new local or parameter name must not match another local or parameter of the same function (nested closures included), a member of the class or its superclasses, a class or package-level function used in the file, or an AS3 keyword or top-level name.
- A new member name must not match another member of the class, its superclasses or its subclasses, or a local or parameter of any function that references the member.
- No new name may match a top-level package name (`tutorial`, `alternativa`, `embed`, `movieclips`, `flash`, `mx`, `br`, `org`).
- **Private members:** rename within the declaring class only. The same word in another file is a different symbol.
- **Non-private members:** search for the whole word across `src/` and account for every declaration and reference. If the word is declared in more than one class, treat the declarations as one family: one name that fits all of them, or no rename. Update all references in the same change.
- After editing, search `src/` again for each renamed non-private member's old name; no references should remain.
- Stop and report, without renaming, if the word occurs inside a string literal, or if a reference to it sits in an excluded directory.
- Replace whole identifiers only, never substrings.

## Mapping files

`utils/mapping.json` and `utils/packagemap.json` record the deobfuscation that was already applied. They cover classes, methods and accessors only, so a random-word field will not be in them. Both are large: search them for the whole word you need, never read them whole.

```
packagemap.json  { "<obf package>:<obf class>": "<package>:<Class>" }
mapping.json     { "<obf package>": { "<obf class>": { "<obf path>": "<real path>" | null } } }
  obf path       pkg:Class/(instance|class)/[namespace:]name[/getter|/setter]    ("class" = static)
  real path      package:Class/[private:|protected:|<namespace>:]name[/get|/set]
```

- A name that appears as a real-path segment is a recovered original name: never rename it.
- A random word in source that appears as an obf-path segment means the mapping was not applied there: report it.
- Ignore `instance/init` and `class/init` entries.

## Workflow for a file

1. Read the whole file. Read its superclass, interfaces and close collaborators as far as needed to understand the members you are naming; use search for the rest.
2. Decide the renames, run the safety checks, apply the edits.
3. Check `git diff`: the line count is unchanged and every changed line differs only in identifier tokens.
4. Do not try to build or run the project. The user compiles it with the VS Code as3mxml build task and reports any compiler errors back.
5. Do not commit. Leave the changes in the working tree for review.

When the user reports compiler errors after a rename, fix them by adjusting or reverting renames only. The rename-only rule still applies, and a successful compile says nothing about runtime behaviour, so the safety checks are not optional.

## Report

End with:

- A table of applied renames: old name, new name, kind (local / parameter / private field / non-private field / constant), scope (function or class), confidence (high / medium), evidence in a few words.
- Identifiers left unrenamed, each with the reason.
- Other files touched by non-private renames.
- Anything out of scope that you noticed (leftover random-word classes or methods, suspected bugs, reused registers).
