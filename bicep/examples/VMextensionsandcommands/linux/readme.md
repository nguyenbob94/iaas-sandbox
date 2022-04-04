# runCommand

When trying to automate Linux VMs. Do not bother with Custom Script extensions because it is a nightmare.

If you want to inject a bash script to perform certain tasks post VM deployment, You're better off using Invoke-AZVmRunCommand for small deployments, and CICD pipelinesfor large scale deployments

#### Example
`Invoke-AZVMrunCommand -ResourceGroupName 'rg-randomname' -VNName 'VM01' -CommandId 'RunShellScript' -ScriptPath 'path/to/bashscript.sh' -Parameter @{"param01" = "value";"param02 = "value"} 


## More reading if you really want to know how the runCommand works

The bicep file in thie folder is an example of its usage. Although I high discourage using it, atleast improvements have been made with the function

https://blog.tyang.org/2022/01/26/azure-bicep-vm-run-cmd
https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines/runcommands?tabs=bicep
https://github.com/tyconsulting/BlogPosts/tree/master/Azure-Bicep/vm-run-cmd