
# Nicholas Ducharme-Barth
# 2025/01/25
# R code to modify a baseline stock synthesis model
# change steepness and run alternative versions of the model

# Copyright (c) 2025 Nicholas Ducharme-Barth

# load packages
    library(r4ss)

# define paths
	proj_dir = this.path::this.proj()
    from_dir = file.path(proj_dir,"stock-synthesis-models","base-model")

    to_dir = file.path(proj_dir,"stock-synthesis-models","mega-merge")
    dir.create(to_dir,recursive=TRUE)
#    dir.create(to_growth_dir,recursive=TRUE)

# read control file
    tmp_ctl = SS_readctl(file=file.path(from_dir,"control.ss"),
                         datlist = file.path(from_dir,"data.ss"))


# modify ##here I can add my revisions
    tmp_ctl$SR_parms["SR_BH_steep","INIT"] = 0.7
# modify
    tmp_ctl$MG_parms["VonBert_K_Fem_GP_1","INIT"] = c(0.2)

    tmp_ctl$natM_type

tmp_ctl$MG_parms["NatM_p_1_Fem_GP_1","INIT"] <- 0.25
tmp_ctl$MG_parms["NatM_p_1_Mal_GP_1","INIT"] <- 0.25

# write out file using r4ss functions
    SS_writectl(tmp_ctl,outfile=file.path(to_dir,"control.ss"),overwrite=TRUE)

# copy over executable & other stock synthesis input files
    dir_exec = file.path(proj_dir,"executables","stock-synthesis","3.30.22.1")
    ss3_exec = "ss3_opt_linux"  
    file.copy(from=file.path(dir_exec,ss3_exec),to=to_dir,overwrite=TRUE)
    file.copy(from=file.path(from_dir,c("data.ss","forecast.ss","starter.ss")),to=to_dir,overwrite=TRUE)

# give permissions to executable
    system(paste0("cd ",to_dir,"; chmod 777 ", ss3_exec))

# run the model
    run(dir=to_dir,exe=ss3_exec,show_in_console=TRUE,skipfinished=FALSE)

# add the r4ss plots
    output = SS_output(to_dir)
    SS_plots(output,dir=to_dir)

    # directories where models were run need to be defined
    dir1 = from_dir
    dir2 = to_dir

    # read two models
    mod1 = SS_output(dir = dir1)
    mod2 = SS_output(dir = dir2)

    # create list summarizing model results
    mod.sum = SSsummarize(list(mod1, mod2))

    # plot comparisons
    plot_dir = file.path(to_dir,"plots","comp")

