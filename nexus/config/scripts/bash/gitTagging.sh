#!/usr/bin/env bash

# Function to create and push a version tag
create_version_tag() {
    # Check if any tags exist
    if [ -z "$(git tag)" ]; then
        # No tags exist, start with initial version
        new_tag="1.0.0"
    else
        # Get the latest tag in the format "major.minor.patch"
        latest_tag=$(git describe --tags --abbrev=0)

        # Split the latest tag into major, minor, and patch components
        IFS='.' read -r major minor patch <<< "$latest_tag"

        # Increment the version based on the input
        case $1 in
            "major")
                major=$((major + 1))
                minor=0
                patch=0
                ;;
            "mod" | "add" | "del")
                minor=$((minor + 1))
                ;;
            "fix")
                patch=$((patch + 1))
                ;;
            *)
                echo "Invalid input. Please specify 'mod', 'add', 'del', 'fix', or 'major'."
                return 1
                ;;
        esac

        # Create the new version tag
        new_tag="$major.$minor.$patch"
    fi

    # Get the shortened commit hash
    commit_hash=$(git rev-parse --short=7 HEAD)

    # Create the new version tag
    git tag -a "$new_tag" -m "Commit hash: $commit_hash"

    echo "Tag -> ${NEW_TAG} for Commit :${COMMIT_HASH}"

    # Push the tag to the remote repository
   ## git push origin "$new_tag"

   ## List tags,
   git tag -n --sort=-v:refname
}

# Example usage: create_version_tag major
create_version_tag $1
