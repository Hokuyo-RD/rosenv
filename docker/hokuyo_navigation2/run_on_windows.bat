@echo off
set IMAGE_NAME=takahashi13/hokuyo_navigation2:v1.0
set CONTAINER_NAME=ros_noetic
set SHARE_FOLDER_PATH=
set SHARE_FOLDER_CMD=
set GPU_CMD=
set CONTAINER_NAME_CMD=--name %CONTAINER_NAME%
set NETHOST_CMD=--net=host

@REM :usage_exit
@REM echo.
@REM echo  -----------------------------------------------------------------------------
@REM echo  OPTIONS                       ^| DETAILS
@REM echo  -----------------------------------------------------------------------------
@REM echo  -g                            ^| GPU enabled
@REM echo  -r                            ^| remove when exit the container
@REM echo  -n CONTAINER_NAME             ^| container name (default : %CONTAINER_NAME% )
@REM echo  -s SHARE_FOLDER_PATH        ^| directory path shared with the inside of the container
@REM echo  -----------------------------------------------------------------------------
@REM exit /b 1

for %%i in (%*) do (
  if "%%i"=="-g" (
    set GPU_CMD=--gpus all
    echo Using nvidia GPUs 1>&2
  ) else if "%%i"=="-r" (
    set REMOVE_CMD=--rm
    set CONTAINER_NAME_CMD=
    echo Remove when exit this container 1>&2
  ) else if "%%i"=="-w" (
    set NETHOST_CMD=
    echo Not using --net=host 1>&2
  ) else if "%%i"=="-n" (
    set CONTAINER_NAME_ARG=1
  ) else if "%%i"=="-s" (
    set SHARE_FOLDER_ARG=1
  ) else if "%%i"=="-h" (
    goto :usage_exit
  ) else if "%%i"=="/?" (
    goto :usage_exit
  ) else if defined CONTAINER_NAME_ARG (
    set CONTAINER_NAME=%%i
    set CONTAINER_NAME_CMD=--name %%i
    echo CONTAINER_NAME = %%i 1>&2
    set CONTAINER_NAME_ARG=
  ) else if defined SHARE_FOLDER_ARG (
    set SHARE_FOLDER_PATH=%%i
    set SHARE_FOLDER_CMD=-v %%i:/home/share
    echo SHARE_FOLDER_PATH = %%i 1>&2
    set SHARE_FOLDER_ARG=
  ) else (
    echo Invalid option: %%i 1>&2
    goto :usage_exit
  )
)

if "%REMOVE_CMD%"=="" (
  cd /d "%USERPROFILE%"
  if not exist "%CONTAINER_NAME%.bat" (
    @REM echo xhost + > "%CONTAINER_NAME%.bat"
    echo docker start %CONTAINER_NAME% >> "%CONTAINER_NAME%.bat"
    echo docker exec -it %CONTAINER_NAME% /bin/bash >> "%CONTAINER_NAME%.bat"
  )
) else (
  set CONTAINER_NAME=
)

docker run -it %CONTAINER_NAME_CMD% ^
           %SHARE_FOLDER_CMD% ^
           -e DISPLAY=host.docker.internal:0 ^
           -e QT_X11_NO_MITSHM=1 ^
           %GPU_CMD% ^
           %REMOVE_CMD% ^
           %NETHOST_CMD% ^
           --privileged ^
           %IMAGE_NAME% /bin/bash