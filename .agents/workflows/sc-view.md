---
description: Scaffolds a new view in dab_app/lib/presentation/views with the correct hierarchy and boilerplate.
---

# Scaffold View (`sc-view`)

This workflow scaffolds a new view in `dab_app/lib/presentation/views` by replicating the structure of the `dashboard` view.

## Arguments
- `[name]`: The name of the view in `snake_case` (e.g., `explorer_v2`).

## Steps

1. **Calculate PascalCase name**:
   Convert the provided `name` from `snake_case` to `PascalCase` (e.g., `explorer_v2` -> `ExplorerV2`).

2. **Create directory structure**:
   Create the following folders:
   - `dab_app/lib/presentation/views/{{name}}`
   - `dab_app/lib/presentation/views/{{name}}/layouts`
   - `dab_app/lib/presentation/views/{{name}}/widgets`

3. **Generate Files**:
   Generate the following files by copying the `dashboard` templates and replacing `dashboard` with `{{name}}` (lowercase) and `Dashboard` with `{{PascalName}}` (uppercase).

### Execution Script

// turbo
```bash
# Set variables (replace '{{name}}' with the argument)
NAME="{{name}}"
# Simple bash logic to convert snake_case to PascalCase
PASCAL_NAME=$(echo "$NAME" | awk -F_ '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)}}1' OFS="")

BASE_PATH="dab_app/lib/presentation/views/$NAME"
DASH_PATH="dab_app/lib/presentation/views/dashboard"

mkdir -p "$BASE_PATH/layouts"
mkdir -p "$BASE_PATH/widgets"

# Template replacement function
template_replace() {
  sed -e "s/dashboard/$NAME/g" -e "s/Dashboard/$PASCAL_NAME/g" "$1" > "$2"
}

# Generate files
template_replace "$DASH_PATH/dashboard_view.dart" "$BASE_PATH/${NAME}_view.dart"
template_replace "$DASH_PATH/dashboard_notifier.dart" "$BASE_PATH/${NAME}_notifier.dart"
template_replace "$DASH_PATH/dashboard_state.dart" "$BASE_PATH/${NAME}_state.dart"
template_replace "$DASH_PATH/layouts/dashboard_view_desktop.dart" "$BASE_PATH/layouts/${NAME}_view_desktop.dart"
template_replace "$DASH_PATH/layouts/dashboard_view_mobile.dart" "$BASE_PATH/layouts/${NAME}_view_mobile.dart"

echo "Scaffolded $PASCAL_NAME ($NAME) in $BASE_PATH"
```

4. **Regenerate Mappers**:
   After creating the files, run code generation to create the `.mapper.dart` files.

// turbo
```bash
cd dab_app && dart run build_runner build --delete-conflicting-outputs
```
