# ros1_bridge environment on Docker Desktop Windows

hrjp/rosenv の noetic を改良して、ros1_bridge の実行環境を作成しました。ROS1とROS2のメッセージの双方向変換ができます。VcXsrv が必要です。

本パッケージの目的は、ROS1のソフトウェアリソースを活用したROS2のデバッグです。例えば、ROS2化されていないソフトウェアをROS1で動作させて、トピックをROS2に変換させて、ROS2化したソフトウェアをテストする等ができます。逆にROS2で作ったソフトウェアの通信テストをROS1で受け取ることができます。

特徴は以下の3点です。
1. Windows で動作可能 (Docker Desktop on Windows、 WSL2 Ubuntu上のDocker)
2. Docker内部でROS1とROS2が共存している環境を一つのイメージにまとめている。
3. DockerとホストUbuntuOS間でROS2のトピック通信を行うことができる。

Windows での動作のために、実行ファイルはDocker Desktopではbat ファイル
WSL2 では従来のbash ファイルで行うように分けました。

# Command 一覧

1. ## Build Image
    To clone the current relesse:
    ```bash:bash
    git clone https://github.com/Hokuyo-RD/rosenv.git
    ```
    clone image:
    ```
    docker pull takahashi13/ros1_noetic:takahashi13/ros1_noetic:v2.0_bridge
    ```

2. ## Run a Docker container based on image
    To run a docker container based on user/image:
    ```
    run_on_windows.bat -n <your-favorite-container-name> -s <path-to-your-file-shared-directory>
    ```

ホスト、ゲスト共通
---------------------------------------------------------
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export ROS_DOMAIN_ID=0


roscore terminal
---------------------------------------------------------
```
source /opt/ros/noetic/setup.bash
```

ros1_bridge terminal
---------------------------------------------------------
```
source /opt/ros/noetic/setup.bash
source /opt/ros/foxy/setup.bash
source /home/ros1_bridge_ws/install/setup.bash
ros2 run ros1_bridge dynamic_bridge --bridge-all-topics
```

ros1 terminal
---------------------------------------------------------
```
source /opt/ros/noetic/setup.bash
source /home/catkin_ws/devel/setup.bash
```

ros2 terminal
---------------------------------------------------------
```
source /opt/ros/foxy/setup.bash
source /home/colcon_ws/install/setup.bash
```

# つまりどころ

Docker のROS2 とホストのROS2と通信ができない。

https://github.com/ros2/ros2/issues/1318

https://discourse.ros.org/t/ros-cross-distribution-communication/27335

https://docs.ros.org/en/foxy/Concepts/About-Domain-ID.html

https://zenn.dev/array/books/raspi_os_de_hajimeru_ros2_2/viewer/p00_06_network

- コンテナ作成時のオプションで
--net=host --ipc=host の両方をつけずに起動する。
- ```export RMW_IMPLEMENTATION=rmw_fastrtps_cpp``` をDocker側とホストPC側で実行する。
- ```export ROS_DOMAIN_ID=5``` をDocker側とホストPC側で実行する。ROS_DOMAIN_IDは0～65532で、Docker 側とホストで共通の番号でしか通信を行わない