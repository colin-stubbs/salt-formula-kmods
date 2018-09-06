# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "kmods/map.jinja" import kmods_map with context %}

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
{% endfor %}

{% for kmod_name in kmods_map.blacklist %}
kmod-{{ kmod_name }}-blacklist:
  file.managed:
    - name: {{ kmods_map.lookup.locations.modprobe_d }}/{{ kmod_name }}.conf
    - contents: blacklist {{ kmod_name }}
    - user: root
    - group: root
    - mode: 0640
{% endfor %}

{# EOF #}
