# Arquitetura do Projeto

## Estrutura de Arquivos

.
├── .vscode/  # Configurações do editor (vazio)
├── build/    # Artefatos de compilação (vazio)
├── app/      # Código principal da aplicação
│ ├── assets/               # Recursos estáticos
│ │ ├── favicon/
│ │ │ └── icon.png
│ │ ├── fonts/                          # (vazio)
│ │ ├── images/                         # (vazio)
│ │ ├── shaders/                        # (vazio)
│ │ └── sounds/                         # (vazio)
│ ├── data/                 # Dados e configurações
│ │ ├── config_base.lua
│ │ ├── config_override.lua
│ │ ├── config_user.lua
│ │ └── update_cache.lua
│ ├── docs/
│ │ └── ARCHITECTURE.md # Este arquivo
│ ├── libs/                 # Bibliotecas externas
│ │ ├── luajit/                         # Repositório padrão do LuaJIT
│ │ └── os/                             # Implementações específicas por SO
│ │ ├── windows/                                    # (vazio)
│ │ └── ...                                         # Outros sistemas
│ └── src/                  # Código-fonte principal
│ ├── engine/                           # Núcleo do motor
│ │ ├── core/                                       # Componentes fundamentais
│ │ │ ├── app.lua
│ │ │ ├── config_validator.lua
│ │ │ ├── event_system.lua
│ │ │ ├── kernel.lua
│ │ │ ├── logger.lua
│ │ │ ├── panel.lua
│ │ │ ├── state_manager.lua
│ │ │ └── utils.lua
│ │ ├── ecs/                                        # Sistema ECS
│ │ │ ├── component_factory.lua
│ │ │ ├── entity.lua
│ │ │ ├── pool_manager.lua
│ │ │ └── world.lua
│ │ └── subsystems/                                 # Subsistemas especializados
│ │ ├── asset_loader.lua
│ │ ├── device_info.lua
│ │ ├── profiler.lua
│ │ ├── update_checker.lua
│ │ └── viewport.lua
│ └── modules/                          # Módulos da aplicação
│ ├── entities/                                     # (vazio)
│ ├── panels/                                       # (vazio)
│ ├── states/
│ │ └── state_zero.lua
│ └── systems/                                      # Sistemas especializados
│ ├── animation/
│ │ ├── components/
│ │ │ └── factory.lua
│ │ ├── core/
│ │ │ ├── blend.lua
│ │ │ ├── system.lua
│ │ │ └── tween_manager.lua
│ │ ├── presets/
│ │ │ ├── default_presets.lua
│ │ │ └── index.lua
│ │ └── init.lua
│ ├── input/
│ │ ├── components/
│ │ │ └── factory.lua
│ │ ├── core/
│ │ │ ├── system.lua
│ │ │ └── ...
│ │ └── init.lua
│ ├── physics/          # (omitido)
│ └── ui/               # (omitido)
├── backup/     # Versões anteriores
│ ├── v1/               # (conteúdo omitido)
│ ├── v2/               # (conteúdo omitido)
│ └── ...               # Outras versões
├── config.lua # Configuração global
├── main.lua   # Ponto de entrada
└── README.md  # Documentação inicial