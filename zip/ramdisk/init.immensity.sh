#!/system/bin/sh
#
# File Type      : Ramdisk Script
# Github         : UtsavisGreat <utsavbalar1231@gmail.com>
# xda-developers : UtsavTheGreat
# Kernel name    : IMMENSITY

setimmensityConfig() {

sleep 5

# IO block tweaks for better system performance;
for i in /sys/block/*/queue; do
  echo "0" > $i/add_random;
  echo "0" > $i/iostats;
  echo "0" > $i/nomerges;
  echo "96" > $i/nr_requests;
  echo "256" > $i/read_ahead_kb;
  echo "0" > $i/rotational;
  echo "1" > $i/rq_affinity;
done;

# Tweak and decrease tx_queue_len default stock value(s) for less amount of generated bufferbloat and for gaining slightly faster network speed and performance;
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;

# Set Max-Frequency
echo "2016000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "2016000" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq

# Disable slice_idle on supported block devices
for block in mmcblk0 mmcblk1 dm-0 dm-1 sda; do
    echo "0" > /sys/block/$block/queue/iosched/slice_idle
done;

# configure governor settings for little cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 1401600 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo 90 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_load
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl
echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable

# Disable MSM Thermal Core-control
echo "0" > /sys/module/msm_thermal/core_control/enabled

# Setup stune parameters
echo 980000 > /proc/sys/kernel/sched_rt_runtime_us
echo 1500000 > /proc/sys/kernel/sched_latency_ns
echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns
echo 10000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
echo 1 > /dev/stune/schedtune.prefer_idle
echo 0 > /dev/stune/cgroup.clone_children
echo 0 > /dev/stune/cgroup.sane_behavior
echo 0 > /dev/stune/notify_on_release
echo 0 > /dev/stune/top-app/schedtune.sched_boost
echo 0 > /dev/stune/top-app/notify_on_release
echo 0 > /dev/stune/top-app/cgroup.clone_children
echo 0 > /dev/stune/foreground/schedtune.sched_boost
echo 0 > /dev/stune/foreground/notify_on_release
echo 0 > /dev/stune/foreground/cgroup.clone_children
echo 0 > /dev/stune/background/schedtune.sched_boost
echo 0 > /dev/stune/background/notify_on_release
echo 0 > /dev/stune/background/cgroup.clone_children
echo 0 > /dev/cpuset/cgroup.clone_children
echo 0 > /dev/cpuset/cgroup.sane_behavior
echo 0 > /dev/cpuset/notify_on_release
echo 0 > /dev/cpuctl/cgroup.clone_children
echo 0 > /dev/cpuctl/cgroup.sane_behavior
echo 0 > /dev/cpuctl/notify_on_release
echo 1000000 > /dev/cpuctl/cpu.rt_period_us
echo 0 > /dev/stune/top-app/schedtune.prefer_idle
echo 1 > /dev/stune/foreground/schedtune.prefer_idle
echo 1 > /dev/stune/background/schedtune.prefer_idle
echo 1 > /dev/stune/rt/schedtune.prefer_idle

    # Memory management.  Basic kernel parameters, and allow the high
    # level system server to be able to adjust the kernel OOM driver
    # parameters to match how it is managing things.
    echo "45" > /proc/sys/vm/overcommit_ratio
    echo "4" > /proc/sys/vm/min_free_order_shift

    echo "200" > /proc/sys/vm/dirty_expire_centisecs
    echo "7" > /proc/sys/vm/dirty_background_ratio
    chown root system /sys/module/lowmemorykiller/parameters/adj
    chmod 0664 /sys/module/lowmemorykiller/parameters/adj
    chown root system /sys/module/lowmemorykiller/parameters/minfree
    chmod 0664 /sys/module/lowmemorykiller/parameters/minfree

# A couple of minor kernel entropy tweaks & enhancements for a slight UI responsivness boost;
echo "128" > /proc/sys/kernel/random/read_wakeup_threshold
echo "96" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "1024" > /proc/sys/kernel/random/write_wakeup_threshold

# Set read ahead to 128 kb for external storage
# The rest are handled by qcom-post-boot
echo "128" > /sys/block/mmcblk1/queue/read_ahead_kb

# Display/fingerprint wakeup delay fix
chown system:system /sys/devices/soc/qpnp-fg-18/power_supply/bms/hi_power
chmod 0660 /sys/devices/soc/qpnp-fg-18/power_supply/bms/hi_power
echo "1" > /sys/devices/soc/qpnp-fg-18/power_supply/bms/hi_power

# Disable in-kernel sched statistics for reduced overhead;
echo "0" > /proc/sys/kernel/sched_schedstats

# FileSystem (FS) optimized tweaks & enhancements for a improved userspace experience;
echo "0" > /proc/sys/fs/dir-notify-enable
echo "30" > /proc/sys/fs/lease-break-time

# Marginally reduce suspend latency
echo "1" > /sys/module/printk/parameters/console_suspend


}

setimmensityConfig &
