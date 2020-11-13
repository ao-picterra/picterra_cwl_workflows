#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Create detector from folder
doc: Given a folder and a name, creates a detector with this name and trainable on the rasters in the folder
inputs:
  api_key: string
  api_server: string
  raster_folder_id: string
  detector_name: string
outputs:
  detector_id:
    type: string
    outputSource: create_detector_with_rasters/detector_id
steps:
  list_rasters_in_folder:
    run:
      cwlVersion: v1.0
      class: CommandLineTool
      label: List of rasters IDs (of the authenticated user) optionally in a folder
      doc: The picterra CLI call needs to return a valid JSON
      baseCommand: [python3, -m, picterra, list, rasters]
      requirements:
        EnvVarRequirement:
          envDef:
            PICTERRA_API_KEY: $(inputs.api_key)
            PICTERRA_BASE_URL: $(inputs.api_server)
        InlineJavascriptRequirement: {}
      inputs:
        api_key: string
        api_server: string
        folder_id:
          type: string?
          inputBinding:
            position: 1
            prefix: --folder
      # We redirect the output of the command (a JSON strin) to this temporary file
      # https://www.commonwl.org/v1.0/CommandLineTool.html#CommandLineTool
      stdout: out.json
      outputs:
        rasters_ids_list:
          type:
            type: array
            items: string
          outputBinding:
            loadContents: true
            glob: "out.json"
            outputEval: |
              ${
                var res = JSON.parse(self[0].contents).map(e => e.id)
                console.log(res);
                return res;
              }
    in:
      api_key: api_key
      api_server: api_server
      folder_id: raster_folder_id
    out: [rasters_ids_list]

  create_detector_with_rasters:
    run:
      cwlVersion: v1.0
      class: CommandLineTool
      baseCommand: [python3, -m, picterra, create, detector]
      requirements:
        EnvVarRequirement:
          envDef:
            PICTERRA_API_KEY: $(inputs.api_key)
            PICTERRA_BASE_URL: $(inputs.api_server)
      inputs:
        api_key: string
        api_server: string?
        name:
          type: string?
          inputBinding:
            position: 1
            prefix: --name
        detection_type:
          type: string?
          label: Type of detection
          inputBinding:
            position: 2
            prefix: --detection-type
        output_type:
          type: string?
          label: Type of output
          inputBinding:
            position: 3
            prefix: --output-type
        training_steps:
          type: int?
          label: Number of training steps (100-4000)
          inputBinding:
            position: 4
            prefix: --training-steps
          default: 1000
        rasters_ids:
          # https://www.commonwl.org/user_guide/09-array-inputs/index.html
          type: string[]?
          label: List of raster IDs
          inputBinding:
            separate: true
            position: 5
            prefix: -r
            itemSeparator: " "
      stdout: output.txt
      outputs:
        detector_id:
          type: string
          outputBinding:
            glob: output.txt
            loadContents: True
            outputEval: $(self[0].contents)
    in:
      api_key: api_key
      api_server: api_server
      name: detector_name
      rasters_ids: list_rasters_in_folder/rasters_ids_list
    out: [detector_id]
