#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [python3, -m, picterra, create, detection_area]
requirements:
  EnvVarRequirement:
    envDef:
      PICTERRA_API_KEY: $(inputs.api_key)
      PICTERRA_BASE_URL: $(inputs.api_server)
inputs:
  api_key: string
  api_server: string
  geometries:
    type: File
    inputBinding:
      position: 1
  raster:
    type: string
    inputBinding:
      position: 2
  
outputs: []
