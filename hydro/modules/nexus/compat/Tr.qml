pragma Singleton

import Quickshell
import qs.services

Singleton {
    function tr(text: string): string {
        return Translation.tr(text);
    }

    function trCtx(text: string, context: string): string {
        return Translation.tr(text);
    }
}
