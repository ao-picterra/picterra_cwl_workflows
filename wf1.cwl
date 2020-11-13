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
    run: list_rasters.cwl
    in:
      api_key: api_key
      api_server: api_server
      folder_id: raster_folder_id
    out: [rasters_ids_list]

  create_detector_with_rasters:
    run: create_detector.cwl
    in:
      api_key: api_key
      api_server: api_server
      name: detector_name
      rasters_ids: list_rasters_in_folder/rasters_ids_list
    out: [detector_id]
