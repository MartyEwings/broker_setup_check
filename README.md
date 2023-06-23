# broker_setup_check

## Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)


## Description

This Module provides a plan to determine if the pxp-agent on the compilers in your system are correctly configured to connect to the broker on the Primary Server.

This prevents issue where the compilers have been misconfigured to point to themselves or other compilers, which is one of the most common reasons for upgrade and configuration and other orchestration failures.


## Usage

Simply Run the plan broker_setup_check::broker_setup_check and observe the output, there are no required input parameters as all the target information is determined programatically.



