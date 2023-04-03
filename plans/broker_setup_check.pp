plan broker_setup_check::broker_setup_check(
  TargetSpec $compilers = puppetdb_query('inventory[certname]{ facts.pe_status_check_role = "pe_compiler" }').map |$r| { $r['certname'] },
) {
  # Run the task against all compiler nodes
  $broker_results = run_task('broker_setup_check::get_agent_broker', $compilers)
  # Build a PQL query to find all primary nodes
  $primary_node = puppetdb_query('inventory[certname]{ facts.pe_status_check_role = "primary" }').map |$r| { $r['certname'] }

  $broker_results.each |$compilers, $result| {
    notice("The broker for compiler ${compilers} is ${result['value']['broker_uri']}")
  }
}
