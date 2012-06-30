object PHPMediaInfo: TPHPMediaInfo
  OldCreateOrder = False
  Version = '0.0'
  Functions = <
    item
      FunctionName = 'mediainfo_list_constants'
      Tag = 0
      Parameters = <>
      OnExecute = php_mediainfo_list_constants
    end>
  Constants = <
    item
      Name = 'MEDIAINFO_STREAM_GENERAL'
      ConstantType = tpInteger
      Value = 0
    end
    item
      Name = 'MEDIAINFO_STREAM_VIDEO'
      ConstantType = tpInteger
      Value = 1
    end
    item
      Name = 'MEDIAINFO_STREAM_AUDIO'
      ConstantType = tpInteger
      Value = 2
    end
    item
      Name = 'MEIDAINFO_STREAM_TEXT'
      ConstantType = tpInteger
      Value = 3
    end
    item
      Name = 'MEDIAINFO_STREAM_CHAPTERS'
      ConstantType = tpInteger
      Value = 4
    end
    item
      Name = 'MEDIAINFO_STREAM_IMAGE'
      ConstantType = tpInteger
      Value = 5
    end
    item
      Name = 'MEDIAINFO_STREAM_MENU'
      ConstantType = tpInteger
      Value = 6
    end
    item
      Name = 'MEDIAINFO_STREAM_MAX'
      ConstantType = tpInteger
      Value = 7
    end
    item
      Name = 'MEDIAINFO_INFO_NAME'
      ConstantType = tpInteger
      Value = 0
    end
    item
      Name = 'MEDIAINFO_INFO_TEXT'
      ConstantType = tpInteger
      Value = 1
    end
    item
      Name = 'MEDIAINFO_INFO_MEASURE'
      ConstantType = tpInteger
      Value = 2
    end
    item
      Name = 'MEDIAINFO_INFO_OPTIONS'
      ConstantType = tpInteger
      Value = 3
    end
    item
      Name = 'MEDIAINFO_INFO_NAME_TEXT'
      ConstantType = tpInteger
      Value = 4
    end
    item
      Name = 'MEDIAINFO_INFO_MEASURE_TEXT'
      ConstantType = tpInteger
      Value = 5
    end
    item
      Name = 'MEDIAINFO_INFO_INFO'
      ConstantType = tpInteger
      Value = 6
    end
    item
      Name = 'MEDIAINFO_INFO_HOWTO'
      ConstantType = tpInteger
      Value = 7
    end
    item
      Name = 'MEDIAINFO_INFO_MAX'
      ConstantType = tpInteger
      Value = 8
    end
    item
      Name = 'MEDIAINFO_INFOOPTION_SHOWININFORM'
      ConstantType = tpInteger
      Value = 0
    end
    item
      Name = 'MEDIAINFO_INFOOPTION_RESERVED'
      ConstantType = tpInteger
      Value = 1
    end
    item
      Name = 'MEDIAINFO_INFOOPTION_SHOWINSUPPORTED'
      ConstantType = tpInteger
      Value = 2
    end
    item
      Name = 'MEDIAINFO_INFOOPTION_TYPEOFVALUE'
      ConstantType = tpInteger
      Value = 3
    end
    item
      Name = 'MEDIAINFO_INFOOPTION_MAX'
      ConstantType = tpInteger
      Value = 4
    end>
  ModuleName = 'MediaInfo'
  Height = 150
  Width = 215
  object php_mediainfo: TPHPClass
    Properties = <
      item
        Name = 'isload'
        Value = 'false'
      end
      item
        Name = 'mediafile'
      end>
    Methods = <
      item
        Name = 'open'
        Tag = 0
        Parameters = <
          item
            Name = 'filename'
            ParamType = tpString
          end>
        OnExecute = php_mediainfo_open
      end
      item
        Name = 'close'
        Tag = 0
        Parameters = <>
        OnExecute = php_mediainfo_close
      end
      item
        Name = 'option'
        Tag = 0
        Parameters = <
          item
            Name = 'opt'
            ParamType = tpString
          end
          item
            Name = 'val'
            ParamType = tpString
          end>
        OnExecute = php_mediainfo_option
      end
      item
        Name = 'get_inform'
        Tag = 0
        Parameters = <
          item
            Name = 'reserved'
            ParamType = tpInteger
          end>
        OnExecute = php_mediainfo_get_inform
      end
      item
        Name = 'get_i'
        Tag = 0
        Parameters = <
          item
            Name = 'stream_kind'
            ParamType = tpInteger
          end
          item
            Name = 'stream_number'
            ParamType = tpInteger
          end
          item
            Name = 'parameter'
            ParamType = tpInteger
          end
          item
            Name = 'kind_of_info'
            ParamType = tpInteger
          end>
        OnExecute = php_mediainfo_get_i
      end
      item
        Name = 'get_count'
        Tag = 0
        Parameters = <
          item
            Name = 'stream_kind'
            ParamType = tpInteger
          end
          item
            Name = 'stream_number'
            ParamType = tpInteger
          end>
        OnExecute = php_mediainfo_get_count
      end
      item
        Name = 'get'
        Tag = 0
        Parameters = <
          item
            Name = 'stream_kind'
            ParamType = tpInteger
          end
          item
            Name = 'stream_number'
            ParamType = tpInteger
          end
          item
            Name = 'parameter'
            ParamType = tpString
          end
          item
            Name = 'kind_of_info'
            ParamType = tpInteger
          end
          item
            Name = 'kind_of_search'
            ParamType = tpInteger
          end>
        OnExecute = php_mediainfo_get
      end>
    PHPClassName = 'mediainfo'
    Left = 32
    Top = 16
  end
end
