# salt-formula-pyenv
Saltstack formula for pyenv

Sample Pillar
==============

.. code-block:: yaml
pyenv:
  git_repo: https://github.com/pyenv/pyenv.git
  install_folder: .pyenv
  users:
    - ubuntu
