# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "kmods/map.jinja" import kmods_map with context %}

kmod-tools:
  pkg.installed:
    - pkgs: {{ kmods_map.lookup.packages }}

{% for kmod_name, kmod_config in kmods_map.enable.items() %}
kmod-{{ kmod_name }}-enable:
{% if 'config' in kmod_config %}
  file.managed:
    - name: {{ kmods_map.lookup.locations.modprobe_d }}/{{ kmod_name }}.conf
    - contents_pillar: kmods:enable:{{ kmod_name }}:config
    - user: root
    - group: root
    - mode: 0640
{% else %}
  file.absent:
    - name: {{ kmods_map.lookup.locations.modprobe_d }}/{{ kmod_name }}.conf
{% endif %}
{% endfor %}

{% for kmod_name in kmods_map.blacklist %}
kmod-{{ kmod_name }}-blacklist:
  file.managed:
    - name: {{ kmods_map.lookup.locations.modprobe_d }}/{{ kmod_name }}.conf
    - contents: install {{ kmod_name }} /bin/true
    - user: root
    - group: root
    - mode: 0640

kmod-{{ kmod_name }}-unload:
  kmod.absent:
    - name: {{ kmod_name }}

{% endfor %}

{# EOF #}
