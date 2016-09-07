One potentially confusing feature of Agave is its support for virtualizing systems paths. Every registered system specifies both a root directory, <code>rootDir</code>, and a home directory, <code>homeDir</code> attribute in its storage configuration. <code>rootDir</code> tells Agave the absolute path on the remote system that it should treat as <code>/</code>. Similar to the Linux <code>chroot</code> command; no requests made to Agave will ever be resolved to locations outside of <code>rootDir</code>.

<%= partial "includes/tables/21" %>

<code>homeDir</code> specifies the path, relative to <code>rootDir</code>, that Agave should use for relative paths. Since Agave is stateless, there is no concept of a current working directory. Thus, when you specify a path to Agave that does not begin with a <code>/</code>, Agave will always prefix the path with the value of <code>homeDir</code>. The following table gives several examples of how different combinations of <code>rootDir</code>, <code>homeDir</code>, and URL paths will be resolved by Agave. For a deeper dive into this subject, please see the <a href="http://agaveapi.co/documentation/tutorials/data-management-tutorial/understanding-agave-file-paths/" title="Understanding Agave File Paths">Understanding Agave File Paths</a> tutorial.

<%= partial "includes/tables/20" %>