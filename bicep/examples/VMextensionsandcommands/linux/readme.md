# runCommand

When trying to automate Linux VMs. Do not bother with Custom Script extensions because it is a nightmare.

If you want to inject a bash script to perform certain tasks post VM deployment, Use `runCommand` resource among with the `loadTextContent('path')` function in bicep.

The bicep file in thie folder is an example of its usage.

## More reading

https://blog.tyang.org/2022/01/26/azure-bicep-vm-run-cmd
https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachines/runcommands?tabs=bicep
https://github.com/tyconsulting/BlogPosts/tree/master/Azure-Bicep/vm-run-cmd