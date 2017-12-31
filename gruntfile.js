// ------------------------------------------------------------------------
// Gruntfile
// ------------------------------------------------------------------------

module.exports = function(grunt) {
  "use strict"

  grunt.initConfig({
    pkg: grunt.file.readJSON("package.json"),


    // --------------------------------------------------------------------
    // Grunt Tasks
    // --------------------------------------------------------------------

    clean: {
      files: ["modW3IM/**"]
    },
    copy: {
      menu: {
        expand: true,
        cwd: "source/menu/",
        src: "**",
        dest: "modW3IM/bin/config/r4Game/user_config_matrix/pc/"
      },
      combat_scripts: {
        expand: true,
        cwd: "source/modW3IM_Combat/scripts/",
        src: "**",
        dest: "modW3IM/mods/modW3IM_Combat/content/scripts/"
      },
      time_scripts: {
        expand: true,
        cwd: "source/modW3IM_Time/scripts/",
        src: "**",
        dest: "modW3IM/mods/modW3IM_Time/content/scripts/"
      },
      ui_files: {
        expand: true,
        cwd: "source/modW3IM_UI/packed/content/",
        src: "**",
        dest: "modW3IM/mods/modW3IM_UI/content/"
      },
      ui_other: {
        expand: true,
        filter: "isFile",
        cwd: "source/modW3IM_UI/",
        src: ["*"],
        dest: "modW3IM/mods/modW3IM_UI/"
      },
      ui_scripts: {
        expand: true,
        cwd: "source/modW3IM_UI/scripts/",
        src: "**",
        dest: "modW3IM/mods/modW3IM_UI/content/scripts/"
      }
    }
  })

  require("load-grunt-tasks")(grunt)
  require("time-grunt")(grunt)

  grunt.registerTask("build", ["copy"])
  grunt.registerTask("clear", ["clean"])
  grunt.registerTask("default", ["clean", "copy"])
}
