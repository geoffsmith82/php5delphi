object dmPHP: TdmPHP
  OldCreateOrder = False
  OnCreate = PHPExtensionCreate
  Version = '0.0'
  Functions = <>
  Height = 150
  Width = 215
  object idTelnet: TIdTelnet
    Terminal = 'dumb'
    Left = 8
    Top = 8
  end
  object phpTelnet: TPHPClass
    Properties = <
      item
        Name = 'host'
        Value = '127.0.0.1'
      end
      item
        Name = 'port'
        Value = '23'
      end
      item
        Name = 'timeout'
        Value = '600'
      end>
    Methods = <
      item
        Name = 'open'
        Tag = 0
        Parameters = <>
        OnExecute = phpTelnet_open
      end
      item
        Name = 'close'
        Tag = 0
        Parameters = <>
        OnExecute = phpTelnet_close
      end
      item
        Name = 'sendcmd'
        Tag = 0
        Parameters = <>
        OnExecute = phpTelnet_sendcmd
      end
      item
        Name = 'getresult'
        Tag = 0
        Parameters = <>
        OnExecute = phpTelnet_getresult
      end>
    PHPClassName = 'telnet'
    Left = 65
    Top = 9
  end
end
