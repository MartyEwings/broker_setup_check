plan broker_setup_check::broker_setup_check {
  $compiler_nodes = filter_nodes(facts.pe_status_check_role == 'pe_compiler')
  $primary_nodes_query = 'nodes { facts.pe_status_check_role = "primary" }'

  # Run the task against all compiler nodes
  $broker_results = run_task('get_agent_broker', $compiler_nodes)

  # Build a PQL query to find all primary nodes
  $primary_nodes = query_nodes($primary_nodes_query)

  # Extract the broker string from the task results
  $broker_strings = $broker_results.map |$node, $result| { $result['broker_string'] }

  # Compare the broker strings to the PQL query of primary nodes
  if $broker_strings == $primary_nodes {
    notice('configured correctly')
  } else {
    notice('configured incorrectly')
  }
}
