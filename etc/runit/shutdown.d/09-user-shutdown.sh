msg "Shutting down user session..."
killall chromium --wait
sv stop connmand
