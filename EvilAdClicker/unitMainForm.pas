unit unitMainForm;

{$R *.dfm}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, EvilLibrary, IdContext, IdCustomTransparentProxy, IdSocks, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdCmdTCPClient, IdHTTP;

type
  TBot  = class;
  TBots = class;

  TMainForm = class(TForm)
    btnStartStop:      TButton;
    chkUseProxy:       TCheckBox;
    edtFTPProxyHost:   TEdit;
    edtFTPProxyPort:   TEdit;
    edtHTTPProxyHost:  TEdit;
    edtHTTPProxyPort:  TEdit;
    edtSOCKSProxyHost: TEdit;
    edtSOCKSProxyPort: TEdit;
    cmbSOCKSProxyType: TComboBox;
    edtSSLProxyHost:   TEdit;
    edtSSLProxyPort:   TEdit;
    grpProxyConfig:    TGroupBox;
    lblAdLinks:        TLabel;
    lblFTPProxy:       TLabel;
    lblHost:           TLabel;
    lblHTTPProxy:      TLabel;
    lblLog:            TLabel;
    lblPort:           TLabel;
    lblSOCKSHost:      TLabel;
    lblSSLProxy:       TLabel;
    lblTorProxyType:   TLabel;
    mmoAddLinks:       TMemo;
    mmoLog:            TMemo;
    grpBotOptions:     TGroupBox;
    lblBotCount:       TLabel;
    lblBotClickTimer:  TLabel;
    lblSeconds:        TLabel;
    edtBotCount:       TEdit;
    edtBotClickTimer:  TEdit;
    procedure FormCreate(Sender: TObject);
    procedure chkUseProxyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStartStopClick(Sender: TObject);
  private
    FBots: TBots;
  protected
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
  public
    procedure Log(const aText: string);
  end;

  TTimerAction = (taNone, taRegister, taIdentify, taAttack);

  TBotThread = class(TThread)
  private
    FBot: TBot;
  protected
    procedure Execute; override;
    procedure DoTerminate; override;
  end;

  TBot = class(TObject)
  private
    FBots:        TBots;
    FHTTP:        TIdHTTP;
    FIOHandler:   TIdIOHandlerStack;
    FProxy:       TIdSocksInfo;
    FBotIndex:    integer;
    FTimerAction: TTimerAction;
    FAttackCount: integer;
    FThread:      TBotThread;
  protected
    property BotIndex: integer read FBotIndex write FBotIndex;

    procedure OnTimer;
    procedure OnDisconnected(Sender: TObject);

  public
    constructor Create(aBots: TBots; const aBotIndex: integer);
    destructor Destroy; override;

    property AttackCOunt: integer read FAttackCount;
  end;

  TBots = class
  private
    FBots:    array of TBot;
    FCount:   integer;
    FRunning: boolean;
  protected
    procedure ReportBotEvent(aBot: TBot; const aMessage: string);

    procedure AddBotTimer(aBot: TBot; aElapse: cardinal);
    procedure OnTimer(aTimerID: integer);
  public
    constructor Create;
    destructor Destroy; override;

    function AddBot: TBot;
    procedure DelBot(const aIndex: integer); overload;
    procedure ClearBots;

    procedure Run;
    procedure Stop;
    property Running: boolean read FRunning;
  end;

var
  MainForm: TMainForm;

implementation

{ TBotThread }

procedure TBotThread.DoTerminate;
begin
  inherited;
  FBot.FThread := nil;
  FBot := nil;
end;

procedure TBotThread.Execute;
var
  RC: TStringStream;
  i:  integer;
begin
  if (FBot = nil) then
    Exit;

  RC := TStringStream.Create;
  try
    try
      i := (FBot.FAttackCount mod MainForm.mmoAddLinks.Lines.Count);
      FBot.FHTTP.Get(MainForm.mmoAddLinks.Lines[i], RC);
      RC.Position := 0;
      FBot.FBots.ReportBotEvent(FBot, RC.DataString);
    except
      on E: Exception do
        FBot.FBots.ReportBotEvent(FBot, E.Message);
    end;
  finally
    RC.Free;
  end;
end;

{ TBot }

constructor TBot.Create(aBots: TBots; const aBotIndex: integer);
begin
  FBots     := aBots;
  FBotIndex := aBotIndex;

  FTimerAction := taNone;

  FHTTP                   := TIdHTTP.Create(nil);
  FHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows; U; Windows NT 6.1; LANG; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3';
  FHTTP.OnDisconnected    := OnDisconnected;

  if (MainForm.chkUseProxy.Checked) then
  begin
    // HTTP proxy.
    FHTTP.ProxyParams.ProxyServer := MainForm.edtHTTPProxyHost.Text;
    FHTTP.ProxyParams.ProxyPort   := StrToInt(MainForm.edtHTTPProxyPort.Text);

    // SOCKS  proxy.
    FIOHandler                  := TIdIOHandlerStack.Create(nil);
    FProxy                      := TIdSocksInfo.Create(nil);
    FHTTP.IOHandler             := FIOHandler;
    FIOHandler.TransparentProxy := FProxy;

    FProxy.Host    := MainForm.edtSOCKSProxyHost.Text;
    FProxy.Port    := StrToInt(MainForm.edtSOCKSProxyPort.Text);
    FProxy.Version := TSocksVersion(MainForm.cmbSOCKSProxyType);
  end;
  FBots.ReportBotEvent(Self, 'Created.');

  FAttackCount := 0;
  FBots.AddBotTimer(Self, StrToInt(MainForm.edtBotClickTimer.Text) * 1000);
end;

destructor TBot.Destroy;
begin
  if (FThread <> nil) then
    FThread.FBot := nil;

  if (MainForm.chkUseProxy.Checked) then
  begin
    FProxy.Free;
    FIOHandler.Free;
  end;
  FHTTP.Free;
  inherited;
  FBots.ReportBotEvent(Self, 'Destroyed.');
end;

procedure TBot.OnTimer;
begin
  if (FThread = nil) then
  begin
    FThread                 := TBotThread.Create(True);
    FThread.FBot            := Self;
    FThread.FreeOnTerminate := True;
    FThread.Start;
  end;
end;

procedure TBot.OnDisconnected(Sender: TObject);
begin
  FBots.ReportBotEvent(Self, 'Disconnected.');
end;

{ TBots }

constructor TBots.Create;
begin
  FCount := 0;
end;

destructor TBots.Destroy;
begin
  ClearBots;
  inherited;
end;

function TBots.AddBot: TBot;
begin
  Inc(FCount);
  SetLength(FBots, FCount);
  FBots[FCount - 1] := TBot.Create(Self, FCount - 1);
  Result            := FBots[FCount - 1];
end;

procedure TBots.DelBot(const aIndex: integer);
begin

end;

procedure TBots.ClearBots;
var
  i: integer;
begin
  for i := 0 to FCount - 1 do
  begin
    KillTimer(MainForm.Handle, i);
    FBots[i].Free;
  end;
  Finalize(FBots);
  FCount := 0;
end;

procedure TBots.AddBotTimer(aBot: TBot; aElapse: cardinal);
begin
  SetTimer(MainForm.Handle, aBot.BotIndex, aElapse, nil);
end;

procedure TBots.OnTimer(aTimerID: integer);
var
  i: integer;
begin
  for i := 0 to FCount - 1 do
  begin
    if (FBots[i].BotIndex = aTimerID) then
    begin
      FBots[i].OnTimer;
      Exit;
    end;
  end;
end;

procedure TBots.Run;
var
  i: integer;
begin
  FRunning := True;

  for i := 0 to StrToInt(MainForm.edtBotCount.Text) - 1 do
    AddBot;
end;

procedure TBots.Stop;
begin
  ClearBots;
  FRunning := False;
end;

procedure TBots.ReportBotEvent(aBot: TBot; const aMessage: string);
begin
  MainForm.Log('Bot' + IntToStr(aBot.BotIndex) + ': ' + aMessage);
end;

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  FBots := TBots.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FBots.Free;
end;

procedure TMainForm.btnStartStopClick(Sender: TObject);
var
  i: integer;
begin
  if (FBots.Running) then
  begin
    btnStartStop.Caption := 'Start';
    for i := 0 to Self.ControlCount - 1 do
      Self.Controls[i].Enabled := True;
    for i := 0 to grpProxyConfig.ControlCount - 1 do
      grpProxyConfig.Controls[i].Enabled := chkUseProxy.Checked;
    for i := 0 to grpBotOptions.ControlCount - 1 do
      grpBotOptions.Controls[i].Enabled := True;
    FBots.Stop;
  end
  else
  begin
    btnStartStop.Caption := 'Stop';
    for i := 0 to Self.ControlCount - 1 do
      Self.Controls[i].Enabled := False;
    for i := 0 to grpProxyConfig.ControlCount - 1 do
      grpProxyConfig.Controls[i].Enabled := False;
    for i := 0 to grpBotOptions.ControlCount - 1 do
      grpBotOptions.Controls[i].Enabled := False;
    FBots.Run;
  end;

  btnStartStop.Enabled := True;
  mmoLog.Enabled       := True;
end;

procedure TMainForm.chkUseProxyClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to grpProxyConfig.ControlCount - 1 do
    grpProxyConfig.Controls[i].Enabled := chkUseProxy.Checked;

  chkUseProxy.Enabled := True;
end;

procedure TMainForm.Log(const aText: string);
begin
  mmoLog.Lines.Add(aText);
end;

procedure TMainForm.WMTimer(var Message: TWMTimer);
begin
  FBots.OnTimer(Message.TimerID);
end;


end.
