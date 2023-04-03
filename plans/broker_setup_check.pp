plan broker_setup_check::broker_setup_check(
  Optional[TargetSpec] $targets          = undef,
) {
  # Query PuppetDB if $targets is not unspecified
  $_targets = if $targets =~ Undef {
    $certnames_or_error = catch_errors() || {
      puppetdb_query('inventory[certname]{ facts.pe_status_check_role = "pe_complier" }').map |$r| { $r['certname'] }
    }
    if $certnames_or_error =~ Error {
      fail_plan("PuppetDB query failed: ${certnames_or_error}")
    }
    get_targets($certnames_or_error)
  } else {
    get_targets($targets)
  }


  # Run the task against all compiler nodes
  $broker_results = run_task('broker_setup_check::get_agent_broker', $_targets)

  # Build a PQL query to find all primary nodes
  $primary_nodes = puppetdb_query('inventory[certname]{ facts.pe_status_check_role = "primary" }').map |$r| { $r['certname'] }

  # Extract the broker string from the task results
  $broker_strings = $broker_results.map |$node, $result| { $result['broker_string'] }

  # Compare the broker strings to the PQL query of primary nodes
  if $broker_strings == $primary_nodes {
    notice('configured correctly')
  } else {
    notice('configured incorrectly')
  }
}
