{%- from slspath + "/map.jinja" import config with context %}

{% if config.users is defined %}
{% for user in config.users %}
{% if user in salt['user.list_users']() %}
{% if not salt['file.directory_exists' ]('~/{{ user }}/{{ config.install_folder }}') %}
mkdir_pyenv:
  file.directory:
    - name: /home/{{ user }}/{{ config.install_folder }}
    - mode: 755
{% else %}
  cmd.run:
    - name: echo "Directory /home/{{ user }}/{{ config.install_folder }} already exists"
{% endif %}


get_repo:
  git.latest:
    - name: {{ config.git_repo }}
    - target: /home/{{ user }}/{{ config.install_folder }}

prereqs-packages-pyenv:
  pkg.latest:
    - pkgs:
      {% if grains['os'] == 'Ubuntu' %}
      - git
      - make
      - build-essential
      - libssl-dev
      - zlib1g-dev
      - libbz2-dev
      - libreadline-dev
      - libsqlite3-dev
      - wget
      - curl
      - llvm
      - libncurses5-dev
      - xz-utils
      - tk-dev
      - libxml2-dev
      - libxmlsec1-dev
      - libffi-dev
      {% endif %}

append_bashrc:
  file.append:
    - name: /home/{{ user }}/.bashrc
    - text: 
      - "#pyenv environment paths [managed by saltstack]"
      - export PYENV_ROOT="$HOME/.pyenv"
      - export PATH="$PYENV_ROOT/bin:$PATH"

restart_shell:
  cmd.run:
    - runas: {{ user }}
    - name: exec "$SHELL"

{% else %}
  cmd.run:
    - name: echo "User '{{ user }}' does not exist"
{% endif %}
{% endfor %}
{% else %}
  {%- do salt.log.error('No users defined in map or pillar') -%}
{% endif %}

