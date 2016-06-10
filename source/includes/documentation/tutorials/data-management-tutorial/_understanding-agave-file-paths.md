One potentially confusing feature of Agave is its support for virtualizing systems paths. Every registered system specifies both a root directory, `rootDir`, and a home directory, `homeDir` attribute in its storage configuration. `rootDir` tells Agave the absolute path on the remote system that it should treat as `/`. Similar to the Linux `chroot` command; no requests made to Agave will ever be resolved to locations outside of `rootDir`.

[table id=21 /]

`homeDir` specifies the path, relative to `rootDir`, that Agave should use for relative paths. Since Agave is stateless, there is no concept of a current working directory. Thus, when you specify a path to Agave that does not begin with a `/`, Agave will always prefix the path with the value of `homeDir`. The following table gives several examples of how different combinations of `rootDir`, `homeDir`, and URL paths will be resolved by Agave. For a deeper dive into this subject, please see the <a href="http://agaveapi.co/documentation/tutorials/data-management-tutorial/understanding-agave-file-paths/" title="Understanding Agave File Paths">Understanding Agave File Paths</a> tutorial.

[table id=20 /]