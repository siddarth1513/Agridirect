describe('Selenium Test 187', () => {
    it('should perform action 187', async () => {
        await browser.url('https://example.com');
        // TODO: add real steps
        expect(await browser.getTitle()).toBe('Example Domain');
    });
});
