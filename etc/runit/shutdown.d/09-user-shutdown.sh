msg "Shutting down user session..."
killall chromium --wait
sv down connmand
