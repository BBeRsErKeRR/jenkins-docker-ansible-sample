# -*- coding: utf-8 -*-
from __future__ import (absolute_import, division, print_function)

__metaclass__ = type

DOCUMENTATION = '''
    callback: filter_env
    type: aggregate
    short_description: Фильтрация ENV переменных при зачитывании фактов
    description:
      - Данный плагин предназначен для фильтра ENV параметров, в которых содержится символ '.'
      - Current solution not worked on Ansible 2.10 or higher!!!
      - To avoid this problem need filter env variables after start any task
'''
from ansible.plugins.callback import CallbackBase


class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 0.1
    CALLBACK_TYPE = 'aggregate'
    CALLBACK_NAME = 'filter_env'

    SECRET_ENV_KEYS = [
        'SOME_SECRET_HIDDEN_ENV',
    ]

    def __init__(self, *args, **kwargs):
        super(CallbackModule, self).__init__(*args, **kwargs)
        self.task = None
        self.isSetup = False
        self.hosts = []

    def __remove_vars(self, task, host):
        ansible_env = task._variable_manager.get_vars(host=host).get('ansible_env')
        if ansible_env:
            for k in ansible_env.copy().keys():
                if '.' in k or k in self.SECRET_ENV_KEYS:
                    ansible_env.pop(k)
                    if k not in self.SECRET_ENV_KEYS:
                        print('CALLBACK_PLUGIN_MESSAGE: Delete invalid ENV key from host: {} - "{}"'.format(
                            host.get_name(), k))
            task._variable_manager.set_host_facts(host, {'ansible_env': ansible_env})

    def v2_playbook_on_task_start(self, task, is_conditional):
        """
            Поиск таска, отвечающего за сбор фактов
        """
        if task.action in ['setup', 'gather_facts']:
            self.isSetup = True

        if self.isSetup and self.hosts:
            self.hosts = []
            self.isSetup = False

    def playbook_on_setup(self):
        self.isSetup = True

    def v2_runner_on_start(self, host, task):
        """
            В случае, если таск найден, производится фильтрации переменной ansible_env 
        """
        if self.isSetup and task._variable_manager:
            self.__remove_vars(task, host)
            self.hosts.append(host.get_name())
