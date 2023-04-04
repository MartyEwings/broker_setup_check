plan broker_setup_check::broker_setup_check(
  TargetSpec $compilers = puppetdb_query('inventory[certname]{ facts.pe_status_check_role = "pe_compiler" }').map |$r| { $r['certname'] },
) {
  # Run the task against all compiler nodes
  $broker_results = run_task('broker_setup_check::get_agent_broker', $compilers)
  # Build a PQL query to find all primary nodes
  $primary_node = puppetdb_query('inventory[certname]{ facts.pe_status_check_role = "primary" }').map |$r| { $r['certname'] }[0]

  $results = $broker_results.map |$result| {
    $target = $result.target.name
    $broker = $result.value['broker_uri']
    if $result.ok {
      {
        'name'   => $target,
        'broker' => $broker,
        'valid'  => $broker == "wss://${primary_node}:8142/pcp2/"
      }
    } else {
      out::message("${target} errored with a message: ${result.error.message}")
    }
  }

  return $results
}
