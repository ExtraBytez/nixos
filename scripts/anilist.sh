#!bash

if [ -z "$1" ]; then
  echo "Error: Please provide an AniList username."
  exit 1
fi

username="$1"

curl -X POST https://graphql.anilist.co \
  -H "Content-Type: application/json" \
  --data-binary @- <<EOF
{
  "query": "query (\$name: String) { MediaListCollection(userName: \$name, type: ANIME) { lists { name entries { media { title { romaji english } } score } } } }",
  "variables": {
    "name": "$username"
  }
}
EOF
