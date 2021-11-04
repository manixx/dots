# dots

My collection of configuration files for setting up my Linux environment.

## Gists 

### Proper shutdown of Chromium during shutdown 

runit shuts down all services at once during poweroff and doesn't wait 
non-runit services to stop properly. This leads to an issue that Chromium 
doesn't stop properly during shutdown. It kills the `dbus` service, which leads
to an ungracefully shutdown of Chromium. 

Pramatic solution is to kill Chromium during shutdown: 

`/etc/runit/3`: 

```sh  
...

killall chromium --wait

# must be added before this line
sv force-stop /var/service/*
...
```
