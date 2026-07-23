describe('Selenium Test 246', () => {
    it('should perform action 246', async () => {
        await browser.url('https://example.com');
        // TODO: add real steps
        expect(await browser.getTitle()).toBe('Example Domain');
    });
});
