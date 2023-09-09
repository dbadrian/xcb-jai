USE_SYSTEM_LIB :: true;

#if OS == .LINUX {
    #if USE_SYSTEM_LIB {
        LIBXCB_PATH :: "/usr/include/xcb/";
        LIB_PATH :: "";
    } else {
        #assert(false);
        // to lazy to test for now...sorry
        // LIBXCB_PATH :: "libxcb/src";
	    // LIB_PATH :: "";
    }
} else {
	#assert(false);
}

DECLARATIONS_TO_OMIT :: string.[
];

#run {
    set_build_options_dc(.{do_output=false});
    if !generate_bindings() {
        compiler_set_workspace_status(.FAILED);
    }
}

generate_bindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;
	    generate_library_declarations = true;
		array_add(*libpaths, LIB_PATH);

        #if OS == .LINUX {
            output_filename = "generated_linux.jai";
            array_add(*libnames, "libxcb.so");
        } else {
            assert(false);
        }

        array_add(*system_include_paths, GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
        array_add(*include_paths, LIBXCB_PATH);
        array_add(*source_files, tprint("%/xcb.h", LIBXCB_PATH));
        visitor = libxcb_vistor;
        
        try_to_preserve_comments = true;
        generate_compile_time_struct_checks = false;
    }

    return generate_bindings(opts, output_filename);
}

#scope_file

libxcb_vistor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result { 
    return .RECURSE;
}

#import "Basic";
#import "Bindings_Generator";
#import "BuildCpp";
#import "Compiler";
#import "File";
#import "String";
#import "System";