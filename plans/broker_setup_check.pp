plan broker_setup_check::broker_setup_check(
  TargetSpec $compilers = puppetdb_query('inventory[certname]{ facts.pe_status_check_role = "pe_compiler" }').map |$r| { $r['certname'] },
) {
  # Run the task against all compiler nodes
  $broker_results = run_task('broker_setup_check::get_agent_broker', $compilers)

  # Build a PQL query to find all primary nodes
  $primary_nodes = puppetdb_query('inventory[certname]{ facts.pe_status_check_role = "primary" }').map |$r| { $r['certname'] }

  $all_ok = true

  # Iterate over each target and compare its broker results with primary nodes
  $compilers.each |$target| {
    if $broker_results[$target] == $primary_nodes {
      notice("Broker setup check passed for ${target}")
    } else {
      notice("Broker setup check failed for ${target}")
      $all_ok = false
    }
  }

  if $all_ok {
    notice('Broker setup check passed for all targets')
  } else {
    fail('Broker setup check failed for one or more targets')
  }
}
