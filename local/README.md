## Important Note on WSL
If using WSL2 with windows to run your cluster, make sure to create a `.wslconfig` file in your users home directory on Windows. Inside this file, limit the memory and swap that is allocated to the VM:

```
[wsl2]
memory=4GB
swap=2GB
```

If you do not do this, it could result in poor performance or crashes. 

* See: https://learn.microsoft.com/en-us/windows/wsl/wsl-config
* and: https://github.com/microsoft/WSL/issues/4166