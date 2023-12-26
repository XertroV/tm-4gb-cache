[SettingsTab name="Cache Size"]
void Render_Settings_Cache() {
    S_CacheSizeMB = Math::Clamp(UI::InputInt("Cache Size MB", S_CacheSizeMB), 0, 3700);
    UI::Text("Note: Max cache size limited to 3700 to avoid overflow issues (size is measured in bytes as a uint32).");
    auto cacheLimit = GetCacheLimitBytes();
    auto cacheLimitMb = cacheLimit >> 20;
    UI::AlignTextToFramePadding();
    UI::Text("Current Limit: " + (cacheLimitMb) + " MB");
    if (cacheLimitMb != S_CacheSizeMB) {
        UI::SameLine();
        if (UI::Button("Update Cache Limit")) {
            UpdateCacheLimitFromSettings();
        }
    }
    UI::Separator();
    if (_CacheRefreshTime + 10000 > Time::Now) {
        UI::AlignTextToFramePadding();
        UI::Text("Current Cache Usage: " + (_CacheSize >> 20) + " MB");
    } else if (UI::Button("Measure Cache Usage")) {
        _CacheRefreshTime = Time::Now;
        startnew(RefreshCacheSize);
    }
}

void UpdateCacheLimitFromSettings() {
    SetCacheLimitBytes(S_CacheSizeMB << 20);
}

bool CheckOnLoadOkay() {
    auto currLimitMb = GetCacheLimitBytes() >> 20;
    return currLimitMb == 1000 || currLimitMb == S_CacheSizeMB;
}

uint _CacheRefreshTime = 0;
uint64 _CacheSize = 0;

[Setting hidden]
uint S_CacheSizeMB = 3700;

void RefreshCacheSize() {
    try {
        auto cache = Fids::GetProgramDataFolder("Cache");
        _CacheSize = 0;
        MeasureFidSizes(cache);
    } catch {
        NotifyError("Could exception getting cache size: " + getExceptionInfo());
    }
}

void MeasureFidSizes(CSystemFidsFolder@ folder) {
    for (uint i = 0; i < folder.Trees.Length; i++) {
        auto fid = folder.Trees[i];
        MeasureFidSizes(fid);
    }
    for (uint i = 0; i < folder.Leaves.Length; i++) {
        auto fid = folder.Leaves[i];
        MeasureFidSizes(fid);
    }
}

void MeasureFidSizes(CSystemFidFile@ file) {
    _CacheSize += file.ByteSize;
}
