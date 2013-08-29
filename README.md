# tmux.me concept and initial architecture & thoughts

The goal is to build a community driven fully open source public service for
remote pairing.  This service is planned to be called tmux.me.

## Components

Overall I think there are three components:

1. The tmux.me web service.
2. The tmuxme command line tool
3. The tmux.me TCP proxy service

### The tmux.me web service

There will be a web app at http://tmux.me that will let you signup for free
given a unique username, email address, password, and password confirmation.

When signup happens the user is generated a unique API token.

Once you signup you will be able to manage (add, remove) your SSH public keys
and see their unique API token.

Once you have managed your SSH public keys to your content there will be
instructions on getting the command line tool installed and configured so that
you can host your first pairing session.

*Note:* the tmux.me web service also provides an API to obtain users public
keys. It should do this using the following URI

http://tmux.me/api/v1/users/<username>/keys.json

It will also provide an API endpoint to allow the command line tool to notify
the tmux.me service that it has hosted a pairing session. This is done by
POSTing to the following URI:

http://tmux.me/api/v1/pairing/sessions

with the users that were invited to the pairing session and the randomly
selected high numbered port from the tmux.me TCP proxy service. This simply
notfies all the users that there is a pairing session ready for them to join
and provides them the command they should use to join the pairing session.

This endpoint will be used by the command line application 

http://tmux.me/api/v1/pairing/port

Making a GET request to the above will return an available randomly selected
high numbered port that the API believes should be avaialble for use.

### Hosting a pairing session (tmux.me command line tool)

1. user that wants to host a pairing session runs `tmuxme username1 username2...`
2. the `tmuxme` program checks if the `tmuxme` user exists on the machine and
   if it doesn't it creates the `tmuxme` user.
3. the `tmuxme` program fetches all the specified users public ssh keys from a
   wide open public api endpoint, http://tmux.me/api/v1/users/<username>/keys.json
4. the `tmuxme` program modifies the `tmuxme` users `~/.ssh/authorized_keys`
   file to include all the obtained public keys and uses the `authorized_keys`
   'command' option to specify that when those users ssh into the system they
   are forced to automatically run `tmux -S /standard/domain/socket attach`
5. the `tmuxme` program makes a GET request to the Web API asking it for a
   randomly chosen un-used high numbered port number for it to use for a
   remote forward.
6. the `tmuxme` program uses the previously obtained high numbered port and
   attempts to use SSH to create a remote GatewayPort port forward using that
   port. If it fails to create the remote portforward it repeats steps 5 and 6
   until exaustion or success. Note: This is blocking and therefore will be
   spun off as a thread.
7. the `tmuxme` program launches a tmux session using the -S option with the
   standardized unix domain socket. It does this in detached mode though so
   that it doesn't take over the terminal.
7. the `tmuxme` program declares to tmux.me that the pairing session is up
   and ready for the members to connect. It does this by POSTing to
   http://tmux.me/api/v1/pairing_sessions with the usernames of the guests,
   the randomly selected high port from the TCP proxy service, and of course
   the users API token. When the tmux.me service processes this it goes
   through and notifies all the specified users about the session by sending
   them all an e-mail with instructions on how to join the pairing session.
8. the `tmuxme` program attaches to the previously launched tmux session
9. Bi-winning!

### Joining a pairing session (ssh)

At this point the persoing hosting the pairing session should be good to go
and just has to wait for the members to join by running the provided ssh
command which should look something like `ssh tmuxme@tmux.me -p <some random
high port>`

### tmux.me TCP proxy service (ssh)

I will leave the following in as it was original details. However, we have
decided to avoid doing that and simply couple the Web App together with SSH by
using the Web App to maintain /home/tunnel/.ssh/authorized_keys file with all
the signed up users public keys so that any signed up users can use the box
for remote port forwarding. Hence, the reverse proxy service will really be as
easy as the following:

ssh -R 23423:localhost:22 tunnel@tmux.me

The following is old and isn't what we are going to be using. Instead we will
simply be using ssh as shown above.

This basically needs to allow us to do exactly what `ngrok -proto=tcp 22` does
except initiate it from the `tmuxme` command line tool.

1. command line application initiates a TCP connection to tmux.me proxy
   service port
2. the tmux.me proxy service spawns off a process to handle this initiated
   connection.
3. the spawned process then randomly selects a high numbered un-used port and
   binds to that port listening for connections on that port. 
4. the spawned process then replies with the high numbered un-used port it
   randomly selected and bound to.
5. Then while the spawned process listens, when data is found on either socket
   it tosses it over to the other socket, just tunneling traffic through that
   port.
6. When the command line application is closed it should close the TCP
   connection to the tmux.me proxy service.
7. When the spawned process that was handling that connection detects the
   connection being closed it should cancel the binding on the socket and kill
   itself.

Ideally there is no need to authenticate to be able to create this tunnels and
they are simply transient tunnels that we just provide a service for.
