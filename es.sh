#!/bin/bash
# Define a function to delete all the indices
delete_indices() {
  # Get the result of the curl command with -s option
  result=$(curl -s 'localhost:9200/_cat/indices?v')
  # Remove the first line with the headers
  result=${result#*\\n}
  # Loop through each line and extract the index name
  index_names=""
  while read -r line; do
    # Split the line by spaces and get the third field
    index_name=$(echo $line | cut -d' ' -f3)
    # Check if the index name is equal to "index" and skip it if it is
    if [ "$index_name" == "index" ]; then
      continue
    fi
    # Append the index name to the index_names variable with a comma
    index_names+="$index_name,"
  done <<< "$result"
  # Remove the trailing comma
  index_names=${index_names%,}
  # Print the index names
  echo $index_names
  # Delete all the indices
  curl -X DELETE "localhost:9200/$index_names"
}

# Define a function to list all the indices
list_indices() {
  # Run the curl command to get the indices info
  curl 'localhost:9200/_cat/indices?v'
}

# Define a function to show a sweet help
show_help() {
  echo "Welcome to es, a linux Elastic Search utils command."
  echo "Usage: es [option]"
  echo "Options:"
  echo "--delete-indices: delete all the indices from elasticsearch"
  echo "--list-indices: list all the indices from elasticsearch"
  echo "Please be careful with this command as it can delete all your data."
}

# Check the number of arguments
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

# Check the option and call the corresponding function
case $1 in
  --delete-indices)
    delete_indices;;
  --list-indices)
    list_indices;;
  *)
    echo "Invalid option: $1"
    exit 2;;
esac
