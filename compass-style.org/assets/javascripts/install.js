function showInstallCommand() {
    var cmd = $("#existence").val();
    var commands = [];
    var notes = [];
    var project_name = "&lt;myproject>";
    var can_be_bare = true;
    var in_working_dir = false;
    var use_bundler = false;
    if ($("#app-type").val() != "rails") {
      commands.push("$ gem install compass");
    }
    if (cmd == "init") {
        commands.push("$ cd " + project_name);
        in_working_dir = true
        project_name = ".";
        $(".creating").hide();
    } else {
        $(".creating").show();
        if ($("#project_name").val() != "")
          project_name = $("#project_name").val();
    }
    if ($("#app-type").val() == "rails") {
        notes.push("<p class='note warning'>Rails 2.3 and 3.0 users require additional installation steps. For full rails installation and upgrade instructions please refer to the compass-rails <a href='https://github.com/Compass/compass-rails/blob/master/README.md'>README</a>.</p>");
        use_bundler = true;
    }
    if ($("#app-type").val() == "rails") {
        if (cmd == "create") {
            commands.push("$ rails new " + project_name);
            commands.push("$ cd " + project_name);
            in_working_dir = true
            project_name = ".";
        }
        commands.push("> Edit Gemfile and add this:");
        commands.push("   group :assets do");
        commands.push("     gem 'compass-rails'");
        commands.push("     # Add any compass extensions here");
        commands.push("   end");
        commands.push("$ bundle");
        cmd = "init rails";
        can_be_bare = false;
    } else if ($("#app-type").val() == "other") {
        if (cmd == "init") {
            cmd = "create";
        }
    } else if ($("#app-type").val() == "stand-alone") {
        if (cmd == "init") {
            cmd = "install";
            can_be_bare = false;
        }
    }
    var framework = $("#framework").val();
    var create_command;
    if (cmd == "install") {
        create_command = "$ compass install " + framework;
    } else {
        create_command = "$ compass " + cmd;
    }
    if (!in_working_dir) {
      create_command = create_command + " " + project_name;
    }
    if (framework != "compass" && framework != "bare" && cmd != "install") {
        create_command = create_command + " --using " + framework;
    } else if (framework == "bare") {
        if (can_be_bare) {
            create_command = create_command + " --bare";
        } else {
            notes.push("<p class='note warning'>You cannot create a bare project in this configuration. Feel free to remove any stylesheets that you don't want.</p>");
        }
    }
    if ($("#syntax").val() == "sass") {
        create_command = create_command + " --syntax sass";
    }
    if ($("#options").val() == "customized") {
        $("#directories").show();
        if ($("#sassdir").val() != "")
          create_command += " --sass-dir \"" + $("#sassdir").val() + "\"";
        if ($("#cssdir").val() != "")
          create_command += " --css-dir \"" +  $("#cssdir").val() + "\"";
        if ($("#jsdir").val() != "")
          create_command += " --javascripts-dir \"" + $("#jsdir").val() + "\"";
        if ($("#imagesdir").val() != "")
          create_command += " --images-dir \"" + $("#imagesdir").val() + "\"";
    } else {
      $("#directories").hide();
    }
    if (use_bundler) {
      create_command = "$ bundle exec " + create_command.replace(/\$ /,'');
    }
    commands.push(create_command);
    var instructions = "<pre><code>" + commands.join("\n") + "</code></pre>";
    if (instructions.match(/&lt;/)) {
        notes.push("<p class='note'>Note: Values indicated by &lt;&gt; are placeholders. Change them to suit your needs.</em>");
    }
    $("#steps").html(instructions + notes.join(""));
}

function attachMadlibBehaviors() {
    $("#app-type").change(function(event) {
        var val = $(event.target).val();
        if (val == "other") {
            $("#options").val("customized");
            $(".madlib").addClass("customizable");
        } else if (val == "rails") {
            $("#options").val("default");
            $(".madlib").removeClass("customizable");
        } else {
            $(".madlib").addClass("customizable");
        }
    });
    $("#existence, #app-type, #framework, #syntax, #options").change(showInstallCommand);
    $(".madlib input").keyup(function(){setTimeout(showInstallCommand, 0.1)});
}

function setupMadlib() {
    attachMadlibBehaviors();
    showInstallCommand();
}

$(setupMadlib);
