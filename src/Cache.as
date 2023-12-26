const uint16 O_PACKMANAGER_CACHELIMIT = 0xD8;

uint GetCacheLimitBytes() {
    auto packMgr = GetApp().Network.FileTransfer.PackManager;
    return Dev::GetOffsetUint32(packMgr, O_PACKMANAGER_CACHELIMIT);
}

void SetCacheLimitBytes(uint limitBytes) {
    auto packMgr = GetApp().Network.FileTransfer.PackManager;
    Dev::SetOffset(packMgr, O_PACKMANAGER_CACHELIMIT, limitBytes);
}
