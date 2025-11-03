import { useEffect, useState } from 'react'
import { WarningCircle } from '@phosphor-icons/react'
import { getConfigWarnings, isThirdwebConfigured } from '@/lib/thirdweb'

/**
 * Component to display configuration warnings for Thirdweb setup
 * Shows a banner if the Thirdweb client ID is not configured
 */
export function ConfigWarning() {
  const [warnings, setWarnings] = useState<string[]>([])
  const [dismissed, setDismissed] = useState(false)

  useEffect(() => {
    // Check if Thirdweb is configured on mount
    if (!isThirdwebConfigured()) {
      setWarnings(getConfigWarnings())
    }
  }, [])

  if (warnings.length === 0 || dismissed) {
    return null
  }

  return (
    <div className="fixed bottom-4 left-4 right-4 md:left-auto md:right-4 md:max-w-md z-50">
      <div className="glass-card border-l-4 border-accent p-4 shadow-lg">
        <div className="flex items-start gap-3">
          <WarningCircle size={24} weight="fill" className="text-accent flex-shrink-0 mt-0.5" />
          <div className="flex-1 min-w-0">
            <h3 className="font-semibold text-sm mb-1">Configuration Notice</h3>
            <div className="space-y-2">
              {warnings.map((warning, index) => (
                <p key={index} className="text-xs text-muted-foreground">
                  {warning}
                </p>
              ))}
              <p className="text-xs text-muted-foreground mt-2">
                See{' '}
                <a
                  href="/DEPLOYMENT.md"
                  className="text-primary hover:underline"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  DEPLOYMENT.md
                </a>{' '}
                for setup instructions.
              </p>
            </div>
          </div>
          <button
            onClick={() => setDismissed(true)}
            className="text-muted-foreground hover:text-foreground transition-colors"
            aria-label="Dismiss warning"
          >
            ✕
          </button>
        </div>
      </div>
    </div>
  )
}
