#Patch Life

Sometimes in Ruby, it's necessary to backport things like security fixes and stability patches to earlier versions, because upgrading a large-scale ecosystem in ruby can require many months of testing, bug fixes, partial rollouts, etc. Occasionally, you need a way to apply newer fixes to older Ruby runtimes.

But, as often happens, large scale ecosystems tend to collect dust, and hide secrets. Todays quick thinking patch could be tomorrows unexpected production issue, because lets face it - you're going to forget you ever did this in 6 months.

The first, uses a Warning, printed every time your application starts, when the patch is loaded. If your defined Ruby Version and Patch level are equal to or older than the version of Ruby you're running the application with, you'll receive a Warning.

```ruby
PatchLife.define_patch do
  version         '1.9.3'
  patch_level     448
  message         "It's time to remove me, as you've upgraded to a version of ruby where this code is no longer needed"
end

#Dirty hack that is considered a bold move goes here
```

The second, allows you to pass the patch into define_patch_life as a block, only to be executed if the defined version / patch level of Ruby is not equal to or higher than the Ruby Version the application is running with.

```ruby
PatchLife.define_patch do
  version         '1.9.3'
  patch_level     448
  patch_to_apply  do
    #World saving code goes here
  end
end
```

You can also combine the two, and have the patch execute only if ruby is beneath it's defined version, and have the message emitted as a Warning as well

```ruby
PatchLife.define_patch do
  version         '1.9.3'
  patch_level     448
  message         "It's time to remove me, as you've upgraded to a version of ruby where this code is no longer needed"
  patch_to_apply  do
    #Code that will be the cause of much scorn and derision when this bites someone in the ass goes here
  end
end
```

##Upcoming Features

Ability to define arbitrary checks to apply patches with (not just based on ruby version)
