# Things that need doing

* Add validation to the SSH public keys to make sure that people can't put
  invalid key values in and break the authorized_keys file. Use
  https://github.com/bensie/sshkey/blob/master/lib/sshkey.rb for reference.
* Make it so that when you signup it gives you the option to provide a key
  name and value to stream line the getting going process.
* Add GitHub account integration so that you can connect your GitHub account
  and it will pull your public keys in.
* Make the notify of created pair session endpoint require an API key to
  prevent people abusing the system and spamming users.
