describe('Selenium Test 96', () => {
    it('should perform action 96', async () => {
        await browser.url('https://example.com');
        // TODO: add real steps
        expect(await browser.getTitle()).toBe('Example Domain');
    });
});
