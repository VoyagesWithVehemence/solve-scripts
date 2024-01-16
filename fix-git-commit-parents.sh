# Used for 2024 MIT MH https://mythstoryhunt.world/puzzles/the-10000-commit-git-repository
# Input is a git repo with commits all out of order (parents mixed up)

# Generate sorted.txt as just a simple list of commit hashes with first commit first.
# Note: This didn't quite work for sorting as there were multiple commits with identical timestamps
#       Instead had to manually run another command to generate sorted.txt based on the commit messages
git log --pretty=format:"%ad %H" --date=iso | sort | awk '{print $4}' > sorted.txt

# Start with an empty parent.  The first commit is going to get its parent replaced with None
parent=""

# For each commit hash, generate a replacement with the current parent and print out the resulting commit hash
while IFS= read -r hash; do
    git replace --graft $hash $parent           
    parent=$(git rev-parse refs/replace/$hash)
    echo $parent
done < sorted.txt
