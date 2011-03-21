function showInstallCommand() {
    var cmd = $("#existence").val();
    var commands = [];
    var notes = [];
    var project_name = "&lt;myproject>";
    var can_be_bare = true;
    commands.push("$ gem install compass");
    if (cmd == "init") {
        commands.push("$ cd " + project_name);
        project_name = ".";
    }
    if ($("#app-type").val() == "rails") {
        if (cmd == "create") {
            commands.push("$ rails new " + project_name);
        }
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
        create_command = "$ compass install " + framework + " " + project_name;
    } else {
        create_command = "$ compass " + cmd + " " + project_name;
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
        create_command = create_command +
                         " --sass-dir \"" + $("#sassdir").val() + "\"" +
                         " --css-dir \"" + $("#cssdir").val() + "\"" +
                         " --javascripts-dir \"" + $("#jsdir").val() + "\"" +
                         " --images-dir \"" + $("#imagesdir").val() + "\"";
    } else {
      $("#directories").hide();
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
